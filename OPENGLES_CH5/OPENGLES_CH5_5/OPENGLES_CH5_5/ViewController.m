//
//  ViewController.m
//  OPENGLES_CH5_5
//
//  Created by Gguomingyue on 2017/9/21.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
#import "AGLKTextureTransformBaseEffect.h"

@interface ViewController ()

@end

@implementation ViewController

// This data type is used to store information for each vertex
typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textureMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);
    self.textureScaleFactor = 1.0;
    
    // Verify the type of view created automatically by the Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0 shading language programs and set constants to be used for all subsequent rendering
    self.baseEffect = [[AGLKTextureTransformBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f,
                                                   1.0f,
                                                   1.0f,
                                                   1.0f);
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle.png"].CGImage;
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.enabled = GL_TRUE;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_S value:GL_REPEAT];
    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_T value:GL_REPEAT];
    
    GLKMatrixStackLoadMatrix4(self.textureMatrixStack, self.baseEffect.textureMatrix2d1);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    GLKMatrixStackPush(self.textureMatrixStack);
    
    // Scale and rotate about the center of the texture
    GLKMatrixStackTranslate(self.textureMatrixStack, 0.5, 0.5, 0.0);
    GLKMatrixStackScale(self.textureMatrixStack, self.textureScaleFactor, self.textureScaleFactor, 1.0);
    GLKMatrixStackRotate(self.textureMatrixStack, GLKMathDegreesToRadians(self.textureAngle), 0.0, 0.0, 1.0);
    GLKMatrixStackTranslate(self.textureMatrixStack, -0.5, -0.5, 0.0);
    
    self.baseEffect.textureMatrix2d1 = GLKMatrixStackGetMatrix4(self.textureMatrixStack);
    [self.baseEffect prepareToDrawMultitextures];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
    GLKMatrixStackPop(self.textureMatrixStack);
    self.baseEffect.textureMatrix2d1 = GLKMatrixStackGetMatrix4(self.textureMatrixStack);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)takeTextureScaleFactorFrom:(UISlider *)sender {
    self.textureScaleFactor = [sender value];
}

- (IBAction)takeTextureAngleFrom:(UISlider *)sender {
    self.textureAngle = [sender value];
}
@end
