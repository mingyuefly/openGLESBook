//
//  UtilityModel+skinning.h
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/13.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityModel.h"

@interface UtilityModel (skinning)

-(void)assignJoint:(NSUInteger)anIndex;
-(void)automaticallySkinRigidWithJoints:(NSArray *)joints;
-(void)automaticallySkinSmoothWithJoints:(NSArray *)joints;

@end
