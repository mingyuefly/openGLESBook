//
//  TETerrain+viewAdditions.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/24.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "TETerrain+modelAdditions.h"
#import <GLKit/GLKit.h>

@class GLKTextureInfo;
@class UtilityCamera;
@class UtilityTerrainEffect;
@class UtilityPickTerrainEffect;
@class UtilityModelEffect;
@class UtilityModelManager;

// The only vertex attribute needed for terrain rendering is "position"
typedef enum
{
    TETerrainPositionAttrib,
    TETerrainNumberOfAttributes
}TETerrainAttribute;

@interface TETerrain (viewAdditions)

-(NSArray *)tiles;
-(void)prepareTerrainAttributes;
-(void)drawTerrainWithinTiles:(NSArray *)tiles
                   withCamera:(UtilityCamera *)aCamera
                terrainEffect:(UtilityTerrainEffect *)aTerrainEffect;
-(void)drawModelsWithinTiles:(NSArray *)tiles
                  withCamera:(UtilityCamera *)aCamera
                 modelEffect:(UtilityModelEffect *)aModelEffect
                modelManager:(UtilityModelManager *)modelManager;
-(void)prepareToPickTerrain:(NSArray *)tiles withCamera:(UtilityCamera *)aCamera PickEffect:(UtilityPickTerrainEffect *)aPickEffect;


@end








