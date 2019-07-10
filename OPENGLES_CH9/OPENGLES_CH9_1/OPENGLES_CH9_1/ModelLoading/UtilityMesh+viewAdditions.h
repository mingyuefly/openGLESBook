//
//  UtilityMesh+viewAdditions.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityMesh.h"

@interface UtilityMesh (viewAdditions)

-(void)prepareToDraw;
-(void)prepareToPick;
-(void)drawCommandsInRange:(NSRange)aRange;
-(void)drawBoundingBoxStringForCommandsInRange:(NSRange)aRange;

@end
