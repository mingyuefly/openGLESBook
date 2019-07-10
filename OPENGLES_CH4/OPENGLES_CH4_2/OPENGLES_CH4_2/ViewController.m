//
//  ViewController.m
//  OPENGLES_CH4_2
//
//  Created by Gguomingyue on 2017/9/15.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

// This data is used to store information for each vertex.
typedef struct
{
    GLKVector3 position;
    GLKVector2 textureCoords;
}SceneVertex;

// This data type is used to store information for triangles.
typedef struct {
    SceneVertex vertices[3];
}SceneTriangle;

// Define the positions and texture coords of each vertex in the example.
static SceneVertex vertexA = {{-0.5,  0.5, -0.5}, {0.0, 1.0}};
static SceneVertex vertexB = {{-0.5,  0.0, -0.5}, {0.0, 0.5}};
static SceneVertex vertexC = {{-0.5, -0.5, -0.5}, {0.0, 0.0}};
static SceneVertex vertexD = {{ 0.0,  0.5, -0.5}, {0.5, 1.0}};
static SceneVertex vertexE = {{ 0.0,  0.0,  0.0}, {0.5, 0.5}};
static SceneVertex vertexF = {{ 0.0, -0.5, -0.5}, {0.5, 0.0}};
static SceneVertex vertexG = {{ 0.5,  0.5, -0.5}, {1.0, 1.0}};
static SceneVertex vertexH = {{ 0.5,  0.0, -0.5}, {1.0, 0.5}};
static SceneVertex vertexI = {{ 0.5, -0.5, -0.5}, {1.0, 0.0}};

// Forward function declarations
static SceneTriangle SceneTriangleMake(
    const SceneVertex vertexA,
    const SceneVertex vertexB,
    const SceneVertex vertexC
);

@interface ViewController ()
{
    SceneTriangle triangles[8];
}

@end

@implementation ViewController

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
                                                   1.0,
                                                   1.0,
                                                   1.0,
                                                   1.0);
    {
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, 0.25f);
        
        self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    }
    
    CGImageRef blandSimulatedLightingImageRef = [[UIImage imageNamed:@"Lighting256x256.png"] CGImage];
    self.blandTextureInfo = [GLKTextureLoader textureWithCGImage:blandSimulatedLightingImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    
    CGImageRef interestingSimulatedImageRef = [[UIImage imageNamed:@"LightingDetail256x256.png"] CGImage];
    self.interestingTextureInfo = [GLKTextureLoader textureWithCGImage:interestingSimulatedImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles)/sizeof(SceneVertex) bytes:triangles usage:GL_DYNAMIC_DRAW];
    self.shouldUseDetailLighting = YES;
}
 
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (self.shouldUseDetailLighting) {
        self.baseEffect.texture2d0.name = self.interestingTextureInfo.name;
        self.baseEffect.texture2d0.target = self.interestingTextureInfo.target;
    } else {
        self.baseEffect.texture2d0.name = self.blandTextureInfo.name;
        self.baseEffect.texture2d0.target = self.blandTextureInfo.target;
    }
    
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, position) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(triangles)/sizeof(SceneVertex)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeShouldUseDetailLightingFrom:(UISwitch *)sender
{
    self.shouldUseDetailLighting = sender.isOn;
}
 
@end

#pragma mark - Triangle mantipulation
static SceneTriangle SceneTriangleMake(
                                       const SceneVertex vertexA,
                                       const SceneVertex vertexB,
                                       const SceneVertex vertexC
                                       )
{
    SceneTriangle result;
    result.vertices[0] = vertexA;
    result.vertices[1] = vertexB;
    result.vertices[2] = vertexC;
    return result;
}

