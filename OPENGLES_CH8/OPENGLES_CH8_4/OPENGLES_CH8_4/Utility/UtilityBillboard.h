//
//  UtilityBillboard.h
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface UtilityBillboard : NSObject

@property (nonatomic, assign, readonly) GLKVector3 position;
@property (nonatomic, assign, readonly) GLKVector2 minTextureCoords;
@property (nonatomic, assign, readonly) GLKVector2 maxTextureCoords;
@property (nonatomic, assign, readonly) GLKVector2 size;
@property (nonatomic, assign, readonly) GLfloat distanceSquared;

-(instancetype)initWithPosition:(GLKVector3)aPosition
                           size:(GLKVector2)aSize
               minTextureCoords:(GLKVector2)minCoords
               maxTextureCoords:(GLKVector2)maxCoords;
-(void)updateWithEyePosition:(GLKVector3)eyePosition
               lookDirection:(GLKVector3)lookDirection;

@end

// Function used to sort particles by distance
extern NSComparisonResult UtilityCompareBillboardDistance(UtilityBillboard *a, UtilityBillboard *b, void *context);





