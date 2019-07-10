//
//  ViewController.m
//  OpenGLES_Ch3_4
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

@interface ViewController ()

@end

@implementation ViewController

//This data type is used to store information for every vertex
typedef struct{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertics[] =
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
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
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
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertics)/sizeof(SceneVertex) bytes:vertics usage:GL_STATIC_DRAW];
    
    // setup texture0
    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    self.textureInfo0 = [GLKTextureLoader
                         textureWithCGImage:imageRef0
                         options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [NSNumber numberWithBool:YES],
                                                                                GLKTextureLoaderOriginBottomLeft, nil]
                         error:NULL];
    
    // setup texture1
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle.png"].CGImage;
    
    self.textureInfo1 = [GLKTextureLoader
                         textureWithCGImage:imageRef1
                         options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [NSNumber numberWithBool:YES],
                                                                                GLKTextureLoaderOriginBottomLeft, nil]
                         error:NULL];
    //[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft的搭配是为了命令GLKit的GLKTextureLoader类垂直反转图像数据，这个反转可以抵消图像的圆点与OpenGLES标准原点之间的差异
    /*
    self.textureInfo1 = [GLKTextureLoader
                         textureWithCGImage:imageRef1
                         options:nil
                         error:NULL];
    */
    // Enable fragment blending with Frame Buffer contents
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using the vertices in the currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertics)/sizeof(SceneVertex)];
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertics)/sizeof(SceneVertex)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
