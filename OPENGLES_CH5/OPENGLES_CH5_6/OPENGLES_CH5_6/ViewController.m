//
//  ViewController.m
//  OPENGLES_CH5_6
//
//  Created by Gguomingyue on 2017/9/25.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface ViewController ()

@end

@implementation ViewController

static const GLfloat SceneEarthAxialItltDeg = 23.5f;
static const GLfloat SceneDaysPerMoonOrbit = 28.0f;
static const GLfloat SceneMoonRadiusFractionOfEarth = 0.25f;
static const GLfloat SceneMoonDistanceFromEarth = 3.0f;

// Setup a light to simulate the Sun
-(void)configureLight
{
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    self.baseEffect.light0.position = GLKVector4Make(
                                                     1.0f,
                                                     0.0f,
                                                     0.8f,
                                                     0.0f);
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.2f,
                                                         0.2f,
                                                         0.2f,
                                                         1.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelviewMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    [self configureLight];
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho
    (-1.0f * 4.0f / 3.0f,
     1.0f * 4.0f / 3.0f,
     -1.0f,
     1.0f,
     1.0f,
     120.0f);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereVerts)/(3 * sizeof(GLfloat)) bytes:sphereVerts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereNormals)/(3 * sizeof(GLfloat)) bytes:sphereNormals usage:GL_STATIC_DRAW];
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(2 * sizeof(GLfloat)) numberOfVertices:sizeof(sphereTexCoords)/(2 * sizeof(GLfloat)) bytes:sphereTexCoords usage:GL_STATIC_DRAW];
    
    // Setup Earth texture
    CGImageRef earthImageRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    self.earthTextureInfo = [GLKTextureLoader textureWithCGImage:earthImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    CGImageRef moonImageRef = [[UIImage imageNamed:@"Moon256x128.png"] CGImage];
    self.moonTextureInfo = [GLKTextureLoader textureWithCGImage:moonImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:NULL];
    
    // Initialize the matrix stack
    GLKMatrixStackLoadMatrix4(self.modelviewMatrixStack, self.baseEffect.transform.modelviewMatrix);
    
    // Initialize Moon position in orbit
    self.moonRotaionAngleDegrees = -20.0f;
}

// Draw the Earth
-(void)drawEarth
{
    self.baseEffect.texture2d0.name = self.earthTextureInfo.name;
    self.baseEffect.texture2d0.target = self.earthTextureInfo.target;
    
    GLKMatrixStackPush(self.modelviewMatrixStack);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(SceneEarthAxialItltDeg), 1.0f, 0.0f, 0.0f);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.earthRotationAngleDegrees), 0.0f, 1.0f, 0.0f);
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using vertices in the prepared vertex buffers
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];
    GLKMatrixStackPop(self.modelviewMatrixStack);
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
}

// Draw the Moon
-(void)drawMoon
{
    self.baseEffect.texture2d0.name = self.moonTextureInfo.name;
    self.baseEffect.texture2d0.target = self.moonTextureInfo.target;
    
    GLKMatrixStackPush(self.modelviewMatrixStack);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.moonRotaionAngleDegrees), 0.0f, 1.0f, 0.0f);
    GLKMatrixStackTranslate(self.modelviewMatrixStack, 0.0f, 0.0f, SceneMoonDistanceFromEarth);
    GLKMatrixStackScale(self.modelviewMatrixStack, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth);
    GLKMatrixStackRotate(self.modelviewMatrixStack, GLKMathDegreesToRadians(self.moonRotaionAngleDegrees), 0.0f, 1.0f, 0.0f);
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using vertices in the prepared vertex buffer
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];
    GLKMatrixStackPop(self.modelviewMatrixStack);
    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    self.earthRotationAngleDegrees += 360.0f / 60.0f;
    self.moonRotaionAngleDegrees += (360.0f / 60.0f)/SceneDaysPerMoonOrbit;
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexTextureCoordBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];
    
    [self drawEarth];
    [self drawMoon];
    
    [(AGLKContext *)view.context enable:GL_DEPTH_TEST];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation !=
            UIInterfaceOrientationPortraitUpsideDown &&
            interfaceOrientation !=
            UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)takeShouldUsePerspectiveFrom:(UISwitch *)sender {
    GLfloat aspectRatio = (float)((GLKView *)self.view).drawableWidth/(float)((GLKView *)self.view).drawableHeight;
    if ([sender isOn]) {
        self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeFrustum(-1.0f * aspectRatio, 1.0f * aspectRatio, -1.0f, 1.0f, 1.0f, 120.0f);
    } else {
        self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1.0f * aspectRatio, 1.0f * aspectRatio, -1.0f, 1.0f, 1.0f, 120.0f);
    }
}
@end
