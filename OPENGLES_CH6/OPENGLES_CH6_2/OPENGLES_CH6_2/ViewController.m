//
//  ViewController.m
//  OPENGLES_CH6_2
//
//  Created by Gguomingyue on 2017/9/29.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "SceneAnimatedMesh.h"

@interface ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) SceneAnimatedMesh *animatedMesh;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGLES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGLES 2.0 shading language programs and set constants to be used for all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.6f,
                                                         0.6f,
                                                         0.6f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    self.baseEffect.light0.position = GLKVector4Make(
                                                     1.0f,
                                                     0.8f,
                                                     0.4f,
                                                     0.0f);
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    
    // Create a mesh to animate
    self.animatedMesh = [[SceneAnimatedMesh alloc] init];
    
    // Set the modelview matrix to match current eye and look-at positions
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(
                                                                     20, 25, 5,
                                                                     20, 0, -15,
                                                                     0, 1, 0);
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing)
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), aspectRatio, 0.1f, 255.0f);
    [self.animatedMesh updateMeshWithElapsedTime:self.timeSinceLastResume];
    
    // Draw the mesh
    [self.baseEffect prepareToDraw];
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
