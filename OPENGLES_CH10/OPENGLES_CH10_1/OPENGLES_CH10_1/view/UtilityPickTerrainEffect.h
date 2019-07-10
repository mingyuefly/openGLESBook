//
//  UtilityPickTerrainEffect.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/24.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityEffect.h"
#import <GLKit/GLKit.h>

@class TETerrain;

typedef struct{
    GLKVector2 position;
    unsigned char modelIndex;
}TEPickTerrainInfo;

@interface UtilityPickTerrainEffect : UtilityEffect

@property (nonatomic, assign, readwrite) GLKMatrix4 projectionMatrix;
@property (nonatomic, assign, readwrite) GLKMatrix4 modelviewMatrix;
@property (nonatomic, assign, readwrite) unsigned char modelIndex;

// Designated intializer
-(instancetype)initWithTerrain:(TETerrain *)aTerrain;
-(TEPickTerrainInfo)terrainInfoForProjectionPosition:(GLKVector2)aPosition;

@end
