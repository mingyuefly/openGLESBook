//
//  ViewController.m
//  OPENGLES_CH6_5
//
//  Created by mingyue on 2017/10/7.
//  Copyright © 2017年 G. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKTextureTransformBaseEffect.h"
#import "SceneAnimatedMesh.h"
#import "SceneCanLightModel.h"

// Position of light sources
static const GLKVector4 spotLight0Position = {10.0f, 18.0f, -10.0f, 1.0f};
static const GLKVector4 spotLight1Position = {30.0f, 18.0f, -10.0f, 1.0f};
static const GLKVector4 light2Position = {1.0f, 0.5f, 0.0f, 0.0f};

// Constants used to calculate the texture position of each
// sub-image in a texture atlas that contains still frames from a movie
static const int numberOfMovieFrames = 51;
static const int numberOfMovieFramesPerRow = 8;
static const int numberOfMovieFramesPerColumn = 8;
static const int numberOfFramesPerSecond = 15;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [AGLKContext setCurrentContext:view.context];
    self.baseEffect = [[AGLKTextureTransformBaseEffect alloc] init];
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    self.animatedMesh = [[SceneAnimatedMesh alloc]init];
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(
                                                                     20, 25, 5,
                                                                     20, 0, -15,
                                                                     0, 1, 0);
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    [((AGLKContext *)view.context) enable:GL_BLEND];
    
    self.canLightModel = [[SceneCanLightModel alloc]init];
    
    self.baseEffect.material.ambientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);
    self.baseEffect.lightModelAmbientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);
    
    self.baseEffect.lightingType = GLKLightingTypePerVertex;
    self.baseEffect.lightModelTwoSided = GL_FALSE;
    self.baseEffect.lightModelAmbientColor = GLKVector4Make(0.6f,
                                                            0.6f,
                                                            0.6f,
                                                            1.0f);
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.spotExponent = 20.0f;
    self.baseEffect.light0.spotCutoff = 30.0f;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 0.0f, 1.0f);
    self.baseEffect.light0.specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.baseEffect.light1.enabled = GL_TRUE;
    self.baseEffect.light1.spotExponent = 20.0f;
    self.baseEffect.light1.spotCutoff = 30.0f;
    self.baseEffect.light1.diffuseColor = GLKVector4Make(0.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.light1.specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.baseEffect.light2.enabled = GL_TRUE;
    self.baseEffect.light2Position = light2Position;
    self.baseEffect.light2.diffuseColor = GLKVector4Make(0.5, 0.5f, 0.5f, 1.0f);
    
    self.baseEffect.material.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.material.specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    CGImageRef imageRef0 = [UIImage imageNamed:@"RabbitTextureAtlas.png"].CGImage;
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
}

//
-(void)updateSpotLightDirections
{
    // Tilt the spot lights using periodic functions for simple smooth animation
    self.spotLight0TiltAboutXAngleDeg = -20.0f + 30.0f * sinf(self.timeSinceLastResume);
    self.spotLight0TiltAboutZAngleDeg = 30.0f * cosf(self.timeSinceLastResume);
    self.spotLight1TiltAboutXAngleDeg = 20.0f + 30.0f * cosf(self.timeSinceLastResume);
    self.spotLight1TiltAboutZAngleDeg = 30.0f * sinf(self.timeSinceLastResume);
}

//
-(void)updateTextureTransform
{
    int movieFrameNumber = (int)floor(self.timeSinceLastResume * numberOfFramesPerSecond) % numberOfMovieFrames;
    GLfloat currentRowPosition = (movieFrameNumber % numberOfMovieFramesPerRow) * 1.0f / numberOfMovieFramesPerRow;
    GLfloat currentColumnPosition = (movieFrameNumber / numberOfMovieFramesPerColumn) * 1.0f / numberOfMovieFramesPerColumn;
    
    // Translate to origin of current frame
    self.baseEffect.textureMatrix2d0 = GLKMatrix4MakeTranslation(currentRowPosition, currentColumnPosition, 0.0f);
    self.baseEffect.textureMatrix2d0 = GLKMatrix4Scale(self.baseEffect.textureMatrix2d0, 1.0f/numberOfMovieFramesPerRow, 1.0f/numberOfMovieFramesPerColumn, 1.0f);
}

//
-(void)drawLight0
{
    // Save effect attributes that will be changed
    GLKMatrix4 savedModelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    
    // Translate to the model's position
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Translate(savedModelviewMatrix, spotLight0Position.x, spotLight0Position.y, spotLight0Position.z);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight0TiltAboutXAngleDeg), 1, 0, 0);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight0TiltAboutZAngleDeg), 0, 0, 1);
    
    // Configure light in current coordinate system
    self.baseEffect.light0Position = GLKVector4Make(0, 0, 0, 1);
    self.baseEffect.light0SpotDirection = GLKVector3Make(0, -1, 0);
    self.baseEffect.texture2d0.enabled = GL_FALSE;
    [self.baseEffect prepareToDrawMultitextures];
    [self.canLightModel draw];
    
    // Restore saved attributes
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
}

-(void)drawLight1
{
    GLKMatrix4 savedModelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Translate(savedModelviewMatrix, spotLight1Position.x, spotLight1Position.y, spotLight1Position.z);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight1TiltAboutXAngleDeg), 1, 0, 0);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight1TiltAboutZAngleDeg), 0, 0, 1);
    
    self.baseEffect.light1Position = GLKVector4Make(0, 0, 0, 1);
    self.baseEffect.light1SpotDirection = GLKVector3Make(0, -1, 0);
    self.baseEffect.texture2d0.enabled = GL_FALSE;
    [self.baseEffect prepareToDrawMultitextures];
    [self.canLightModel draw];
    
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self updateSpotLightDirections];
    [self updateTextureTransform];
    
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(80.0f), aspectRatio, 0.1f, 255.0f);
    self.baseEffect.transform.projectionMatrix = GLKMatrix4Rotate(self.baseEffect.transform.projectionMatrix, GLKMathDegreesToRadians(-90.0f), 0.0f, 0.0f, 1.0f);
    [self drawLight0];
    [self drawLight1];
    
    if (self.shouldRipple) {
        [self.animatedMesh updateMeshWithElapsedTime:self.timeSinceLastResume];
    }
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    
    // Draw the mesh
    [self.baseEffect prepareToDrawMultitextures];
    [self.animatedMesh prepareToDraw];
    [self.animatedMesh drawEntireMesh];
}

// This method is called automatically and allows all standard device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takeShouldRippleFrom:(UISwitch *)sender {
    self.shouldRipple = sender.isOn;
    if (!self.shouldRipple) {
        [self.animatedMesh updateMeshWithDefaultPositions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
