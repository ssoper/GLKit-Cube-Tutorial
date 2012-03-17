//
//  ColorfulPyramid.m
//  Cube
//
//  Created by Sean Soper on 3/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "ColorfulPyramid.h"
#define M_TAU (2*M_PI)

static BOOL initialized = NO;
static GLKVector3 vertices[5];
static GLKVector4 colors[5];
static GLKVector3 triangleVertices[18];
static GLKVector4 triangleColors[18];
static GLKBaseEffect *effect;

@implementation ColorfulPyramid

@synthesize position, rotation, scale, rps;

- (id)init
{
  self = [super init];
  if (self) {
    position = GLKVector3Make(0,0,0);
    rotation = GLKVector3Make(0,0,0);
    scale =    GLKVector3Make(1,1,1);
  }

  return self;
}

+ (void)initialize {
  if (!initialized) {
    vertices[0] = GLKVector3Make(-0.5, -0.5,  0.5); // Left  bottom front
    vertices[1] = GLKVector3Make( 0.5, -0.5,  0.5); // Right bottom front
    vertices[2] = GLKVector3Make( 0.0,  0.5,  0.0); // Top    front
    vertices[3] = GLKVector3Make(-0.5, -0.5, -0.5); // Left  bottom back
    vertices[4] = GLKVector3Make( 0.5, -0.5, -0.5); // Right bottom back

    colors[0] = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Red
    colors[1] = GLKVector4Make(0.0, 1.0, 0.0, 1.0); // Green
    colors[2] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue
    colors[3] = GLKVector4Make(0.0, 0.0, 0.0, 1.0); // Black
    colors[4] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue

    int vertexIndices[18] = {
      // Front
      0, 1, 2,
      // Right
      1, 4, 2,
      // Back
      4, 3, 2,
      // Left
      3, 0, 2,
      // Bottom
      3, 4, 1,
      3, 1, 0,
    };

    for (int i = 0; i < 18; i++) {
      triangleVertices[i] = vertices[vertexIndices[i]];
      triangleColors[i] = colors[vertexIndices[i]];
    }

    effect = [[GLKBaseEffect alloc] init];

    initialized = YES;
  }
}

- (void)draw
{
  GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(rotation.x);
  GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(rotation.y);
  GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(rotation.z);
  GLKMatrix4 scaleMatrix     = GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
  GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
  
  GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,GLKMatrix4Multiply(scaleMatrix,GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
  
  GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
  effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
  
  effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
  
  [effect prepareToDraw];
  
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, triangleVertices);
  
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, triangleColors);
  
//  NSLog(@"size %lu", sizeof(triangleVertices)/sizeof(GLKVector3));
  glDrawArrays(GL_TRIANGLES, 0, 18);
  
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (void)updateRotations:(NSTimeInterval)dt {
  rotation = GLKVector3Add(rotation, GLKVector3MultiplyScalar(rps, dt));
}

@end
