//
//  AGLKTextureTransformBaseEffect.h
//  OPENGLES_CH5_5
//
//  Created by Gguomingyue on 2017/9/21.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKTextureTransformBaseEffect : GLKBaseEffect

@property (nonatomic, assign) GLKVector4 light0Position;
@property (nonatomic, assign) GLKVector3 light0SpotDirection;
@property (nonatomic, assign) GLKVector4 light1Position;
@property (nonatomic, assign) GLKVector3 light1SpotDirection;
@property (nonatomic, assign) GLKVector4 light2Position;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d0;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d1;

-(void)prepareToDrawMultitextures;

@end

@interface GLKEffectPropertyTexture (AGLKAdditions)

-(void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end
