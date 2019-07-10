//
//  AGLKContext.h
//  GLTextureLearning
//
//  Created by Gguomingyue on 2017/6/27.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext
{
    GLKVector4 clearColor;
}

@property (nonatomic, assign, readwrite) GLKVector4 clearColor;

-(void)clear:(GLbitfield)mask;
-(void)enable:(GLenum)capability;
-(void)disable:(GLenum)capability;
-(void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;

@end



