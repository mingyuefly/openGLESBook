//
//  UtilityCamera.m
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityCamera.h"
#import "AGLKFrustum.h"

@interface UtilityCamera()
{
    AGLKFrustum frustum;
}
@property (nonatomic, assign, readwrite) BOOL isInCallback;

@end

@implementation UtilityCamera

// Intialize
-(instancetype)init
{
    self = [super init];
    if (self) {
        // Default 45 deg. field of view, square aspect ratio, near distance of 0.5, and far disstance of 5000
        frustum = AGLKFrustumMakeFrustumWithParameters(GLKMathDegreesToRadians(45.0f),
                                                       1.0f,
                                                       0.5f,
                                                       5000.0f);
        // Default eye at origin, look down neg. Z axis,
        // Y axis is "up"
        AGLKFrustumSetPositionAndDirection(&frustum,
                                           GLKVector3Make(0.0f, 0.0f, 0.0f),
                                           GLKVector3Make(0.0f, 0.0f, -1.0f),
                                           GLKVector3Make(0.0f, 1.0f, 0.0f));
    }
    return self;
}

// Set the reciver's frustum shape
-(void)configurePerspectiveFieldOfViewRad:(GLfloat)angle
                              aspectRatio:(GLfloat)anAspectRatio
                                     near:(GLfloat)nearLimit
                                      far:(GLfloat)farLimit
{
    AGLKFrustumSetPerspective(&frustum,
                              angle,
                              anAspectRatio,
                              nearLimit,
                              farLimit);
}

// Return the frustum to be used when culling objects that can't be seen by the camera at it's current position and orientation.
-(const AGLKFrustum *)frustumForCulling
{
    return &frustum;
}

// Return the receiver's "up" direction
-(GLKVector3)upUnitVector
{
    return frustum.yUnitVector;
}

// Return the receiver's eye position
-(GLKVector3)position
{
    return frustum.eyePosition;
}

// Return the receiver's look-at position
-(GLKVector3)lookAtPosition
{
    const GLKVector3 eyePosition = frustum.eyePosition;
    const GLKVector3 lookAtPosition = GLKVector3Add(eyePosition, frustum.zUnitVector);
    return lookAtPosition;
}

// Set the receiver's eye and look-at positions and give optional delegate object opportunity to revise or constrain the specified positions.
-(void)setPostion:(GLKVector3)aPosition lookAtPosition:(GLKVector3)lookAtPosition
{
    if (!self.isInCallback) {
        // Prevent recursive call to -setPosition:lookAtPosition:
        self.isInCallback = YES;
        BOOL shouldMakeChange = YES;
        
        if ([self.delegate respondsToSelector:@selector(camera:willChangeEyePosition:lookAtPosition:)]) {
            shouldMakeChange = [self.delegate camera:self willChangeEyePosition:&aPosition lookAtPosition:&lookAtPosition];
        }
        
        if (shouldMakeChange) {
            const GLKVector3 upUnitVector = GLKVector3Make(0.0f, 1.0f, 0.0f); // Assume Y up
            AGLKFrustumSetPositionAndDirection(&frustum,
                                               aPosition,
                                               lookAtPosition,
                                               upUnitVector);
        }
        self.isInCallback = NO;
    }
}

-(void)setOrientation:(GLKMatrix4)aMatrix
{
    AGLKFrustumSetToMatchModelview(&frustum, aMatrix);
}

// Move the receiver's eye position in orbit around receiver's look-at position: giving the receiver's optional delegate an opportunity to revise or constrain the resulting frustum positions. Positive angles produce counterclockwise orbit about the receiver’s “up” axis.
-(void)rotateAngleRadiansAboutX:(GLfloat)anAngleRadians
{
    GLKMatrix4 modelview = AGLKFrustumMakeModelview(&frustum);
    GLKMatrix4 newmatrix = GLKMatrix4Rotate(modelview,
                                            anAngleRadians,
                                            0.0f,
                                            1.0f,
                                            0.0f);
    AGLKFrustumSetToMatchModelview(&frustum, newmatrix);
}

// Move the receiver's eye position and look-at position by the direction and distance of aVector. This method calls -setPosition:lookAtPosition: giving the receiver's optional delegate an opportunity to revise or constrain the resulting frustum position.
-(void)moveBy:(GLKVector3)aVector
{
    const GLKVector3 currentEyePosition = [self position];
    const GLKVector3 currentLookAtPosition = [self lookAtPosition];
    [self setPostion:GLKVector3Add(currentEyePosition,
                                   aVector)
      lookAtPosition:GLKVector3Add(currentLookAtPosition,
                                   aVector)];
}

-(void)moveTo:(GLKVector3)aVector
{
    
}

// Returns the projection matrix that defines the shape of the receiver's frustum.
-(GLKMatrix4)projectionMatrix
{
    return AGLKFrustumMakePerspective(&frustum);
}

// Returns the model-view matrix that defines the receiver's frustum orientation.
-(GLKMatrix4)modelviewMatrix
{
    return AGLKFrustumMakeModelview(&frustum);
}


@end
