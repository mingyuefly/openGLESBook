//
//  UtilityBillboardManager.m
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityBillboardManager.h"
#import "UtilityBillboard.h"

@interface UtilityBillboardManager ()

@property (nonatomic, strong, readwrite) NSMutableArray *mutableSortedBillboards;

@end

@implementation UtilityBillboardManager

@synthesize mutableSortedBillboards = _mutableSortedBillboards;
@synthesize shouldRenderSpherical = _shouldRenderSpherical;

// Disignated initializer
-(instancetype)init
{
    self = [super init];
    if (self) {
        _mutableSortedBillboards = [@[] mutableCopy];
        _shouldRenderSpherical = YES;
    }
    return self;
}

//
-(void)updateWithEyePosition:(GLKVector3)eyePosition lookDirection:(GLKVector3)lookDirection
{
    // Make sure lookDirection is a unit vector
    lookDirection = GLKVector3Normalize(lookDirection);
    
    for (UtilityBillboard *currentBillboard in self.sortedBillboards) {
        [currentBillboard updateWithEyePosition:eyePosition
                                  lookDirection:lookDirection];
    }
    
    // Sort from furthest to nearest with dead particles and particles behind the viewer ordered before all others. Note: dead particles are available for reuse.
    [self.mutableSortedBillboards sortUsingFunction:UtilityCompareBillboardDistance
                                            context:NULL];
}

// Accessor
-(NSArray *)sortedBillboards
{
    return self.mutableSortedBillboards;
}

// The maximum number of particles allow in the simulation at one time.
static const NSInteger UtilityMaximumNumberOfBillboards = 4000;

// Add aBillboard to the end of the billboards array.
-(void)addBillboard:(UtilityBillboard *)aBillboard
{
    const NSInteger count = self.mutableSortedBillboards.count;
    
    if (UtilityMaximumNumberOfBillboards > count) {
        [self.mutableSortedBillboards addObject:aBillboard];
    } else {
        NSLog(@"Attempt to add too many billboards");
    }
}

//
-(void)addBillboardAtPosition:(GLKVector3)aPosition
                         size:(GLKVector2)aSize
             minTextrueCoords:(GLKVector2)minCoords
             maxTextureCoords:(GLKVector2)maxCoords
{
    UtilityBillboard *newBillboard = [[UtilityBillboard alloc] initWithPosition:aPosition
                                                                           size:aSize
                                                               minTextureCoords:minCoords
                                                               maxTextureCoords:maxCoords];
    [self addBillboard:newBillboard];
}


@end
