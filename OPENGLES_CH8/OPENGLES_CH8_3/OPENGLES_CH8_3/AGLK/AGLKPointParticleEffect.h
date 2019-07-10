//
//  AGLKPointParticleEffect.h
//  OPENGLES_CH8_3
//
//  Created by Gguomingyue on 2017/10/17.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

// Default gravity acceleration vector matches Earth's
// {0, (-9.80665 m/s/s), 0} assuming + Y up coordinate system
extern const GLKVector3 AGLKDefaultGravity;

@interface AGLKPointParticleEffect : NSObject<GLKNamedEffect>

@property (nonatomic, assign) GLKVector3 gravity;
@property (nonatomic, assign) GLfloat elapsedSeconds;
@property (nonatomic, strong, readonly) GLKEffectPropertyTexture *texture2d0;
@property (nonatomic, strong, readonly) GLKEffectPropertyTransform *transform;

-(void)addParticleAtPosition:(GLKVector3)aPosition
                    velocity:(GLKVector3)aVelocity
                       force:(GLKVector3)aForce
                        size:(float)aSize
             lifeSpanSeconds:(NSTimeInterval)aSpan
         fadeDurationSeconds:(NSTimeInterval)aDuration;
-(void)prepareToDraw;
-(void)draw;

@end
