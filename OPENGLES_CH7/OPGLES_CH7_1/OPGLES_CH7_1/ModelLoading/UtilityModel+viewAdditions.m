//
//  UtilityModel+viewAdditions.m
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/10.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityModel+viewAdditions.h"
#import "UtilityMesh+viewAdditions.h"

@implementation UtilityModel (viewAdditions)

// This method draws the receiver using the receiver's UtilityMesh and a UtilityModelEffect that have both already been prepared for drawing.
-(void)draw
{
    [self.mesh drawCommandsInRange:NSMakeRange(indexOfFirstCommand_, numberOfCommands_)];
}

@end
