//
//  UtilityTerrainEffect.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/24.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityEffect.h"
#import <GLKit/GLKit.h>

@class TETerrain;
@class UtilityTextureInfo;

@interface UtilityTerrainEffect : UtilityEffect

@property (nonatomic, assign, readwrite) GLKVector4 globalAmbientLightColor;
@property (nonatomic, assign, readwrite) GLKMatrix4 projectionMatrix;
@property (nonatomic, assign, readwrite) GLKMatrix4 modelviewMatrix;
@property (nonatomic, assign, readwrite) GLKMatrix3 textureMatrix0;
@property (nonatomic, assign, readwrite) GLKMatrix3 textureMatrix1;
@property (nonatomic, assign, readwrite) GLKMatrix3 textureMatrix2;
@property (nonatomic, assign, readwrite) GLKMatrix3 textureMatrix3;
@property (nonatomic, assign, readwrite) UtilityTextureInfo *lightAndWeightsTextureInfo;
@property (nonatomic, assign, readwrite) UtilityTextureInfo *detailTextureInfo0;
@property (nonatomic, assign, readwrite) UtilityTextureInfo *detailTextureInfo1;
@property (nonatomic, assign, readwrite) UtilityTextureInfo *detailTextureInfo2;
@property (nonatomic, assign, readwrite) UtilityTextureInfo *detailTextureInfo3;

// Designated initializer
-(instancetype)initWithTerrain:(TETerrain *)aTerrain;
-(void)prepareToDraw;

@end
