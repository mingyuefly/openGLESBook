//
//  UtilityTextureInfo.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/11.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityTextureInfo : NSObject<NSCoding>

@property (nonatomic, strong, readonly) NSDictionary *plist;
@property (nonatomic, strong, readwrite) id userInfo;

-(void)discardPlist;

@end
