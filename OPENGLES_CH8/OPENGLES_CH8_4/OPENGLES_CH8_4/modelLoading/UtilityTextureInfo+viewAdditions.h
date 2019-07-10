//
//  UtilityTextureInfo+viewAdditions.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/11.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityTextureInfo.h"
#import <GLKit/GLKit.h>

@interface GLKTextureInfo (utilityAdditions)

+(GLKTextureInfo *)textureInfoFromUtilityPlistRepresentation:(NSDictionary *)aDictioanary;

@end

@interface UtilityTextureInfo (viewAdditions)

@property (nonatomic, assign, readonly) GLuint name;
@property (nonatomic, assign, readonly) GLenum target;

@end
