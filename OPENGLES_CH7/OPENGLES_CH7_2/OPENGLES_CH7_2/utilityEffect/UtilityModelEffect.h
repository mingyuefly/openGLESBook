//
//  UtilityModelEffect.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/10.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityEffect.h"

@interface UtilityModelEffect : UtilityEffect

@property (nonatomic, assign, readwrite) GLKMatrix4 projectionMatrix;
@property (nonatomic, assign, readwrite) GLKMatrix4 modelviewMatrix;
@property (nonatomic, assign, readwrite) GLKVector4 globalAmbientLightColor;
@property (nonatomic, assign, readwrite) GLKVector3 diffuseLightDirection;
@property (nonatomic, assign, readwrite) GLKVector4 diffuseLightColor;
@property (nonatomic, strong, readwrite) GLKTextureInfo *texture2D;

-(void)prepareLightColors;
-(void)prepareModelview;
-(void)prepareModelviewWithoutNormal;

@end
