//
//  AGLKContext.h
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext

@property (nonatomic, assign) GLKVector4 clearColor;

-(void)clear:(GLbitfield)mask;
-(void)enable:(GLenum)capability;
-(void)disable:(GLenum)capability;
-(void)setBlendSourceFunction:(GLenum)sfactor
          destinationFunction:(GLenum)dfactor;

@end
