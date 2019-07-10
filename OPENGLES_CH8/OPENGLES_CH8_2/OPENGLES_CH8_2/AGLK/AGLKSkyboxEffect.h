//
//  AGLKSkyboxEffect.h
//  OPENGLES_CH8_2
//
//  Created by Gguomingyue on 2017/10/16.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKSkyboxEffect : NSObject <GLKNamedEffect>

@property (nonatomic, assign) GLKVector3 center;
@property (nonatomic, assign) GLfloat xSize;
@property (nonatomic, assign) GLfloat ySize;
@property (nonatomic, assign) GLfloat zSize;
@property (nonatomic, strong, readonly) GLKEffectPropertyTexture *textureCubeMap;
@property (nonatomic, strong, readonly) GLKEffectPropertyTransform *transform;

-(void)prepareToDraw;
-(void)draw;

@end
