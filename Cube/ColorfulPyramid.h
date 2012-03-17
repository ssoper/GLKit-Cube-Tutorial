//
//  ColorfulPyramid.h
//  Cube
//
//  Created by Sean Soper on 3/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ColorfulPyramid : NSObject {
  GLKVector3 position, rotation, scale, rps;
}

@property GLKVector3 position, rotation, scale, rps;

- (void)draw;
- (void)updateRotations:(NSTimeInterval)dt;

@end
