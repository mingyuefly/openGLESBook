//
//  ViewController.m
//  OPENGLES_CH6_4
//
//  Created by mingyue on 2017/10/2.
//  Copyright © 2017年 G. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKTextureTransformBaseEffect.h"
#import "SceneAnimatedMesh.h"
#import "SceneCanLightModel.h"

// Positions of light sources
static const GLKVector4 spotLight0Position = {10.0f, 18.0f, -10.0f, 1.0f};
static const GLKVector4 spotLight1Position = {30.0f, 18.0f, -10.0f, 1.0f};
static const GLKVector4 light2Position = {1.0f, 0.5f, 0.0f, 0.0f};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Verify the type of view created automatically by the Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGLES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0 shading language programs and set constants to be used for all subsequent rending
    self.baseEffect = [[AGLKTextureTransformBaseEffect alloc] init];
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    
    // Create a mesh to animate
    self.animatedMesh = [[SceneAnimatedMesh alloc] init];
    
    // Set the modelview matrix to match current eye and look-at positions
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(20, 25, 5,
                                                                     20, 0, -15,
                                                                     0, 1, 0);
    
    // Enable depth testing and blending with the frame buffer
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    [((AGLKContext *)view.context) enable:GL_BLEND];
    
    // Create and load the model for a can light
    self.canLightModel = [[SceneCanLightModel alloc] init];
    self.baseEffect.material.ambientColor = GLKVector4Make(0.1f,
                                                           0.1f,
                                                           0.1f,
                                                           1.0f);
    self.baseEffect.lightModelAmbientColor = GLKVector4Make(0.1f,
                                                            0.1f,
                                                            0.1f,
                                                            1.0f);
    
    // Light0 is a spot light
    self.baseEffect.lightingType = GLKLightingTypePerVertex;
    self.baseEffect.lightModelTwoSided = GL_FALSE;
    self.baseEffect.lightModelAmbientColor = GLKVector4Make(0.6f,
                                                            0.6f,
                                                            0.6f,
                                                            1.0f);
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.spotExponent = 20.0f;
    self.baseEffect.light0.spotCutoff = 30.0f;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f,
                                                         1.0f,
                                                         0.0f,
                                                         1.0f);
    self.baseEffect.light0.specularColor = GLKVector4Make(0.0f,
                                                          0.0f,
                                                          0.0f,
                                                          1.0f);
    
    // Light1 is a spot light
    self.baseEffect.light1.enabled = GL_TRUE;
    self.baseEffect.light1.spotExponent = 20.0f;
    self.baseEffect.light1.spotCutoff = 30.0f;
    self.baseEffect.light1.diffuseColor = GLKVector4Make(0.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    self.baseEffect.light1.specularColor = GLKVector4Make(0.0f,
                                                          0.0f,
                                                          0.0f,
                                                          1.0f);
    
    // Light2 is directional
    self.baseEffect.light2.enabled = GL_TRUE;
    self.baseEffect.light2Position = light2Position;
    self.baseEffect.light2.diffuseColor = GLKVector4Make(0.5f,
                                                         0.5f,
                                                         0.5f,
                                                         1.0f);
    
    // Material colors
    self.baseEffect.material.diffuseColor = GLKVector4Make(1.0f,
                                                           1.0f,
                                                           1.0f,
                                                           1.0f);
    self.baseEffect.material.specularColor = GLKVector4Make(0.0f,
                                                            0.0f,
                                                            0.0f,
                                                            1.0f);
    
    // Setup texture0
    CGImageRef imageRef0 = [UIImage imageNamed:@"RadiusSelectionTool.png"].CGImage;
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
}

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
    // Rotate the texture
    // Translate to center of texture coordinate system
    self.baseEffect.textureMatrix2d0 = GLKMatrix4MakeTranslation(0.5f, 0.5f, 0.0f);
    
    // Rotate
    self.baseEffect.textureMatrix2d0 = GLKMatrix4Rotate(self.baseEffect.textureMatrix2d0, -self.timeSinceLastResume, 0, 0, 1);
    
    // Translate back to texture coordinate system origin
    self.baseEffect.textureMatrix2d0 = GLKMatrix4Translate(self.baseEffect.textureMatrix2d0, -0.5f, -0.5f, 0);
}

// This method is called automatically at the update rate of the receiver(default 30 HZ).
-(void)update
{
    [self updateSpotLightDirections];
    [self updateTextureTransform];
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
    
    // Congigure light in current coordinate system
    self.baseEffect.light0Position = GLKVector4Make(0, 0, 0, 1);
    self.baseEffect.light0SpotDirection = GLKVector3Make(0, -1, 0);
    self.baseEffect.texture2d0.enabled = GL_FALSE;
    self.baseEffect.texture2d1.enabled = GL_FALSE;
    
    [self.baseEffect prepareToDrawMultitextures];
    [self.canLightModel draw];
    
    // Rostore saved attributes
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
}

//
-(void)drawLight1
{
    // Save effect attributes that will be changed
    GLKMatrix4 savedModelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    
    // Translate to the model's position
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Translate(savedModelviewMatrix, spotLight1Position.x, spotLight1Position.y, spotLight1Position.z);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight1TiltAboutXAngleDeg), 1, 0, 0);
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4Rotate(self.baseEffect.transform.modelviewMatrix, GLKMathDegreesToRadians(self.spotLight1TiltAboutZAngleDeg), 0, 0, 1);
    
    // Configure light in current coordinate system
    self.baseEffect.light1Position = GLKVector4Make(0, 0, 0, 1);
    self.baseEffect.light1SpotDirection = GLKVector3Make(0, -1, 0);
    self.baseEffect.texture2d0.enabled = GL_FALSE;
    self.baseEffect.texture2d1.enabled = GL_FALSE;
    
    [self.baseEffect prepareToDrawMultitextures];
    [self.canLightModel draw];
    
    // Restore saved attributes
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing)
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT ];
    
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), aspectRatio, 0.1f, 255.0f);
    
    // Draw lights
    [self drawLight0];
    [self drawLight1];
    
    [self.animatedMesh updateMeshWithElapsedTime:self.timeSinceLastResume];
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d1.enabled = GL_FALSE;
    
    // Draw the mesh
    [self.baseEffect prepareToDrawMultitextures];
    [self.animatedMesh prepareToDraw];
    [self.animatedMesh drawEntireMesh];
}

// This method is called automatically and allows all standard device orientations.
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


@end
