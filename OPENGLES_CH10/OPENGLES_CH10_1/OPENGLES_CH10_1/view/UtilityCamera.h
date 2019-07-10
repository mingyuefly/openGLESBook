//
//  UtilityCamera.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "AGLKFrustum.h"

@class UtilityCamera;
@protocol UtilityOpenGLCameraDelegate <NSObject>

@optional
-(BOOL)camera:(UtilityCamera *)aCamera willChangeEyePosition:(GLKVector3 *)eyePositionPtr lookAtPosition:(GLKVector3 *)lookAtPositionPtr;

@end

@interface UtilityCamera : NSObject

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign, readonly) GLKMatrix4 projectionMatrix;
@property (nonatomic, assign, readonly) GLKMatrix4 modelviewMatrix;
@property (nonatomic, assign, readonly) GLKVector3 position;
@property (nonatomic, assign, readonly) GLKVector3 lookAtPosition;
@property (nonatomic, assign, readonly) GLKVector3 upUnitVector;
@property (nonatomic, readonly) const AGLKFrustum *frustumForCulling;

-(void)configurePerspectiveFieldOfViewRad:(GLfloat)angle
                              aspectRatio:(GLfloat)anAspectRatio
                                     near:(GLfloat)nearLimit
                                      far:(GLfloat)farLimit;

-(void)rotateAngleRadiansAboutY:(GLfloat)anAngleRadians;
-(void)rotateAngleRadiansAboutX:(GLfloat)anAngleRadians;

-(void)moveBy:(GLKVector3)aVector;
-(void)moveTo:(GLKVector3)aVector;

-(void)setPostion:(GLKVector3)aPosition
   lookAtPosition:(GLKVector3)lookAtPosition;
-(void)setOrientation:(GLKMatrix4)aMatrix;


@end
