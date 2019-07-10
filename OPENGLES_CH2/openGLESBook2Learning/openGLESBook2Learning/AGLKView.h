//
//  AGLKView.h
//  openGLESBook2Learning
//
//  Created by Gguomingyue on 2017/6/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@class EAGLContext;
@protocol AGLKViewDelegate;

// Type for depth buffer formats.
//typedef enum
//{
//    AGLKViewDrawableDepthFormatNone = 0,
//    AGLKViewDrawableDepthFormat16,
//} AGLKViewDrawableDepthFormat;

@interface AGLKView : UIView
{
    EAGLContext   *context;
    GLuint defaultFrameBuffer;//帧缓存
    GLuint colorRenderBuffer;//像素颜色渲染缓存
    //GLuint        depthRenderBuffer;
    GLint drawableWidth;
    GLint drawableHeight;
}

@property (nonatomic, weak) id<AGLKViewDelegate>delegate;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, readonly) GLsizei drawableWidth;
@property (nonatomic, readonly) GLsizei drawableHeight;
//@property (nonatomic) AGLKViewDrawableDepthFormat drawableDepthFormat;

-(void)display;

@end

#pragma mark - AGLKViewDelegate

@protocol AGLKViewDelegate <NSObject>

@required
-(void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end

