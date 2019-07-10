//
//  TEModelPlacement.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TETerrain;

@interface TEModelPlacement : NSManagedObject

@property (nonatomic) float angle;
@property (nonatomic) int32_t index;
@property (nonatomic, retain) NSString * modelName;
@property (nonatomic) float positionX;
@property (nonatomic) float positionY;
@property (nonatomic) float positionZ;
@property (nonatomic, retain) TETerrain *terrain;

@end
