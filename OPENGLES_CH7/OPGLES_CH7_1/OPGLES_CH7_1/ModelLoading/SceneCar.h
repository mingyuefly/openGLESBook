//
//  SceneCar.h
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "UtilityModel.h"

@protocol SceneCarControllerProtocol

-(NSTimeInterval)timeSinceLastUpdate;
-(AGLKAxisAllignedBoundingBox)rinkBoundingBox;
-(NSArray *)cars;

@end

@interface SceneCar : NSObject

@property (nonatomic, strong, readonly) UtilityModel *model;
@property (nonatomic, assign, readonly) GLKVector3 position;
@property (nonatomic, assign, readonly) GLKVector3 nextPosition;
@property (nonatomic, assign, readonly) GLKVector3 velocity;
@property (nonatomic, assign, readonly) GLfloat yawRadians;
@property (nonatomic, assign, readonly) GLfloat targetYawRadians;
@property (nonatomic, assign, readonly) GLKVector4 color;
@property (nonatomic, assign, readonly) GLfloat radius;

-(instancetype)initWithModel:(UtilityModel *)aModel
                    position:(GLKVector3)aPosition
                    velocity:(GLKVector3)aVelocity
                       color:(GLKVector4)aColor;
-(void)updateWithController:(id<SceneCarControllerProtocol>)controller;
-(void)drawWithBaseEffect:(GLKBaseEffect *)anEffect;

@end

extern GLfloat SceneScalarFastLowPassFilter(NSTimeInterval timeSinceLastUpdate, GLfloat target, GLfloat current);

extern GLfloat SceneScalarSlowLowPassFilter(NSTimeInterval timeSinceLastUpdate, GLfloat target, GLfloat current);

extern GLKVector3 SceneVector3FastLowPassFilter(NSTimeInterval timeSinceLastUpdate, GLKVector3 target, GLKVector3 current);

extern GLKVector3 SceneVector3SlowLowPassFilter(NSTimeInterval timeSinceLastUpdate, GLKVector3 target, GLKVector3 current);









