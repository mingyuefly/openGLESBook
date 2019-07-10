//
//  UtilityBillboardManager.h
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class UtilityBillboard;

@interface UtilityBillboardManager : NSObject

@property (nonatomic, strong, readonly) NSArray *sortedBillboards;
@property (nonatomic, assign, readwrite) BOOL shouldRenderSpherical;

-(void)updateWithEyePosition:(GLKVector3)eyePosition
               lookDirection:(GLKVector3)lookDirection;
-(void)addBillboard:(UtilityBillboard *)aBillboard;
-(void)addBillboardAtPosition:(GLKVector3)aPosition
                         size:(GLKVector2)aSize
             minTextrueCoords:(GLKVector2)minCoords
             maxTextureCoords:(GLKVector2)maxCoords;

@end
