//
//  UtilityJoint.m
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityJoint.h"

@interface UtilityJoint ()

@property (nonatomic, weak, readwrite) UtilityJoint *parent;
@property (nonatomic, strong, readwrite) NSArray *children;
@property (nonatomic, assign, readwrite) GLKVector3 displacement;

@end

@implementation UtilityJoint

// Designed initializer
-(instancetype)initWithDisplacement:(GLKVector3)aDisplacement parent:(UtilityJoint *)aParent
{
    self = [super init];
    if (self) {
        self.displacement = aDisplacement;
        self.parent = aParent;
        self.children = [NSMutableArray array];
        self.matrix = GLKMatrix4Identity;
    }
    return self;
}

// Returns the cumulative matrix that includes parent transforms
-(GLKMatrix4)cumulativeTransforms
{
    GLKMatrix4 result = GLKMatrix4Identity;
    if (self.parent) {
        result = [self.parent cumulativeTransforms];
    }
    
    GLKVector3 d = self.cumulativeDisplacement;
    // Use the classic recipe for transform about a point translate to the location of the joint, retate, and translate back;
    result = GLKMatrix4Translate(result, d.x, d.y, d.z);
    result = GLKMatrix4Multiply(result, self.matrix);
    result = GLKMatrix4Translate(result, -d.x, -d.y, -d.z);
    
    return result;
}

// Returns the cumulative untransformed displacement including parent's cumulative displacement.
-(GLKVector3)cumulativeDisplacement
{
    GLKVector3 result = self.displacement;
    if (self.parent) {
        result = GLKVector3Add(result, [self.parent cumulativeDisplacement]);
    }
    return result;
}

@end
