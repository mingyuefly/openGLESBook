//
//  UtilityBillboardManager+viewAdditions.h
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityBillboardManager.h"

@interface UtilityBillboardManager (viewAdditions)

-(void)drawWithEyePosition:(GLKVector3)eyePosition
             lookDirection:(GLKVector3)lookDirection
                  upVector:(GLKVector3)upVector;

@end
