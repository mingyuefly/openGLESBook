//
//  UtilityJoint.h
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface UtilityJoint : NSObject

@property (nonatomic, weak, readonly) UtilityJoint *parent;
@property (nonatomic, strong, readonly) NSArray *children;
@property (nonatomic, assign, readonly) GLKVector3 displacement;
@property (nonatomic, assign, readwrite) GLKMatrix4 matrix;

-(instancetype)initWithDisplacement:(GLKVector3)aDisplacement parent:(UtilityJoint *)aParent;
-(GLKMatrix4)cumulativeTransforms;
-(GLKVector3)cumulativeDisplacement;

@end
