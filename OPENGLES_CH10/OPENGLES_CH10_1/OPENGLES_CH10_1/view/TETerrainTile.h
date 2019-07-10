//
//  TETerrainTile.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/24.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TETerrain;

@interface TETerrainTile : NSObject

@property (nonatomic, assign, readonly) NSInteger originX;
@property (nonatomic, assign, readonly) NSInteger originY;
@property (nonatomic, strong, readonly) NSSet *containedModelPlacements;

-(instancetype)initWithTerrain:(TETerrain *)aTerrain
                   tileOriginX:(NSInteger)x
                   tileOriginY:(NSInteger)y
                    titleWidth:(NSInteger)aWidth
                    tileLength:(NSInteger)aLength;

-(void)draw;
-(void)drawSimplified;

-(void)manageContainedModelPlacements:(NSSet *)somePlacements;
-(NSSet *)containedModelPlacements;

@end

static const NSInteger TETerrainTileDefaultWidth = 32;
static const NSInteger TETerrainTileDefaultLength = 32;

