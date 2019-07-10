//
//  AGLKView.m
//  openGLESBook2Learning
//
//  Created by Gguomingyue on 2017/6/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGLKView

@synthesize delegate;
@synthesize context;
//@synthesize drawableDepthFormat;


//This method returns the CALayer subclass to be used to be
//CoreAnimation with this view
//CAEAGLayer是Core Animation 提供的标准层类之一。CAEAGLayer会与一个OpenGLES的帧缓存共享它的像素颜色仓库

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO],
                                    kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat, nil];
        self.context = aContext;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        //保护层中用到的OpenGLES的帧缓存类型的信息
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
                                        //不要试图保留任何以前绘制的图像
                                        [NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,
                                        //用8位来保存层内每个像素的每个颜色元素的值
                                        kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    }
    return self;
}

-(void)setContext:(EAGLContext *)aContext
{
    if (context != aContext) {
        //delete any buffers previously created in old Context
        [EAGLContext setCurrentContext:context];
        
        if (0 != defaultFrameBuffer) {
            glDeleteFramebuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        if (0 != colorRenderBuffer) {
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        
//        if (0 != depthRenderBuffer)
//        {
//            glDeleteRenderbuffers(1, &depthRenderBuffer); // Step 7
//            depthRenderBuffer = 0;
//        }
        
        context = aContext;
        
        if (nil != context) {
            context = aContext;
            [EAGLContext setCurrentContext:context];
            
            glGenFramebuffers(1, &defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            
            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            //Attach color render to bound Frame Buffer
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
            
            //[self layoutSubviews];
        }
    }
}

-(EAGLContext *)context
{
    return context;
}

-(void)display
{
    [EAGLContext setCurrentContext:self.context];
    
    //可以用来控制渲染至帧缓存的子集，在这里使用的是整个帧缓存
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    [self drawRect:[self bounds]];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)drawRect:(CGRect)rect
{
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}

//任何在接收到视图重新调整大小的消息时，Cocoa Touch都会调用下边的方法
//This method is called automatically whenever a UIView is resized included just after the view is added to a UIWindow.
-(void)layoutSubviews
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    //Initialize the current Frame Buffer's pixel color buffer
    //so that it shares the corresponding Core Animation Layer's
    //pixel color storage.
    //调整视图的缓存的尺寸以匹配层的新尺寸
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    // Make the Color Render Buffer the current buffer for display
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    //Check for any errors configuring the render buffer
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", status);
    }
}

//This method returns the width in pixels of current context's Pixel Color Render Buffer
-(GLsizei)drawableWidth
{
    GLint backableWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backableWidth);
    return (GLsizei)backableWidth;
}

-(GLsizei)drawableHeight
{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (GLsizei) backingHeight;
}

-(void)dealloc
{
    // Make sure the receiver's OpenGLES Context is not current
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}


@end
