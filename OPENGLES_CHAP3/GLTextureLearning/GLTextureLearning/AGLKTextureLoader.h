//
//  AGLKTextureLoader.h
//  GLTextureLearning
//
//  Created by Gguomingyue on 2017/9/6.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

#pragma mark - AGLKTextureInfo

@interface AGLKTextureInfo : NSObject
{
@private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}

@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;

@end

#pragma mark - AGLKTextureLoader
@interface AGLKTextureLoader : NSObject

+(AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(nullable NSDictionary *)options error:(NSError *)outError;

@end

