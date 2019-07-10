//
//  UtilityModel.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/10.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "AGLKAxisAllignedBoundingBox.h"

@class UtilityMesh;

@interface UtilityModel : NSObject
{
    NSUInteger indexOfFirstCommand_;
    NSUInteger numberOfCommands_;
}

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) UtilityMesh *mesh;
@property (nonatomic, assign, readonly) NSUInteger indexOfFirstCommand;
@property (nonatomic, assign, readonly) NSUInteger numberOfCommands;
@property (nonatomic, assign, readonly) AGLKAxisAllignedBoundingBox axisAlignedBoundingBox;
@property (nonatomic, assign, readonly) BOOL doesRequireLighting;

-(id)initWithName:(NSString *)aName mesh:(UtilityMesh *)aMesh indexOfFirstCommand:(NSUInteger)aFirstIndex numberOfCommands:(NSUInteger)count axisAlignedBoundingBox:(AGLKAxisAllignedBoundingBox)aBoundingBox;

-(id)initWithPlistRepresentation:(NSDictionary *)aDictionary mesh:(UtilityMesh *)aMesh;

@end

// Constants used to access model properties from a plist dictionary.
extern NSString *const UtilityModelName;
extern NSString *const UtilityModelIndexOfFirstCommand;
extern NSString *const UtilityModelNumberOfCommands;
extern NSString *const UtilityModelAxisAlignedBoundingBox;
extern NSString *const UtilityModelDrawingCommand; 









