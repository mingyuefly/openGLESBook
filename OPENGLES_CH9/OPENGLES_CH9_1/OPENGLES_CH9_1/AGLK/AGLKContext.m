//
//  AGLKContext.m
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

@synthesize clearColor = _clearColor;

-(void)setClearColor:(GLKVector4)clearColor
{
    _clearColor = clearColor;
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

-(GLKVector4)clearColor
{
    return _clearColor;
}

-(void)clear:(GLbitfield)mask
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    glClear(mask);
}

-(void)enable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    glEnable(capability);
}

-(void)disable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    glDisable(capability);
}

-(void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor
{
    glBlendFunc(sfactor, dfactor);
}


@end
