//
//  UtilityModelManager+skinning.m
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/13.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityModelManager+skinning.h"
#import "UtilityMesh+skinning.h"

@implementation UtilityModelManager (skinning)

-(void)prepareToDrawWithJointInfluence
{
    [self.consolidatedMesh prepareToDrawWithJointInfluence];
}

@end
