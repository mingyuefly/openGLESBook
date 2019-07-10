//
//  UtilityTextureInfo.m
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/11.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityTextureInfo.h"

@interface UtilityTextureInfo ()

@property (nonatomic, strong) NSDictionary *plist;

@end

// This class exists solely to support unarchiving of UtilityTextureInfo instance archived by external application.

@implementation UtilityTextureInfo

@synthesize plist = plist_;
@synthesize userInfo = userInfo_;

-(void)discardPlist
{
    self.plist = nil;
}

#pragma mark - NSCoding

// This class exists to support unachiving only. Instance should never be encoded.
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSAssert(0, @"Invalid method");
}

// Returns a dictionary caotaining a plist storing unachives attributes.
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.plist = [aDecoder decodeObjectForKey:@"plist"];
    return self;
}






@end
