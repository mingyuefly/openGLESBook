//
//  UtilityBillboard.m
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityBillboard.h"

@interface UtilityBillboard ()

@property (nonatomic, assign, readwrite) GLKVector3 position;
@property (nonatomic, assign, readwrite) GLfloat distanceSquared;

@end

@implementation UtilityBillboard

@synthesize position = _position;
@synthesize size = _size;
@synthesize minTextureCoords = _minTextureCoords;
@synthesize maxTextureCoords = _maxTextureCoords;
@synthesize distanceSquared = _distanceSquared;

// Designated initializer
-(instancetype)initWithPosition:(GLKVector3)aPosition
                           size:(GLKVector2)aSize
               minTextureCoords:(GLKVector2)minCoords
               maxTextureCoords:(GLKVector2)maxCoords
{
    self = [super init];
    if (self) {
        _position = aPosition;
        _size = aSize;
        _minTextureCoords = minCoords;
        _maxTextureCoords = maxCoords;
    }
    return self;
}

// Override of inherited initializer
-(instancetype)init
{
    NSAssert(0, @"Invalid initializer");
    return nil;
}

// Apply Newtonian physics and filters to modify the receiver's position and velocity.
-(void)updateWithEyePosition:(GLKVector3)eyePosition
               lookDirection:(GLKVector3)lookDirection
{
    const GLKVector3 vectorFromEye = GLKVector3Subtract(eyePosition, _position);
    _distanceSquared = GLKVector3DotProduct(vectorFromEye, lookDirection);
}

// Function used to compare particles when sorting.
NSComparisonResult UtilityCompareBillboardDistance(UtilityBillboard *a,
                                                   UtilityBillboard *b,
                                                   void *context)
{
    NSInteger result = NSOrderedSame;
    if (a->_distanceSquared < b->_distanceSquared) {
        // Distance particles are ordered after near ones
        result = NSOrderedDescending;
    } else if (a->_distanceSquared > b->_distanceSquared) {
        // Distance particles are ordered after near ones
        result = NSOrderedAscending;
    }
    return result;
}


@end
