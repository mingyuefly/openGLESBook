//
//  ViewController.m
//  OPENGLES_CH8_2
//
//  Created by Gguomingyue on 2017/10/16.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKSkyboxEffect.h"
#import "UtilityModelManager.h"
#import "UtilityModel+viewAdditions.h"
#import "UtilityTextureInfo+viewAdditions.h"
#import <OpenGLES/ES2/glext.h>

@interface ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKSkyboxEffect *skyboxEffect;
@property (nonatomic, strong) GLKTextureInfo *textureInfo;
@property (nonatomic, assign, readwrite) GLKVector3 eyePosition;
@property (nonatomic, assign) GLKVector3 lookAtPosition;
@property (nonatomic, assign) GLKVector3 upVector;
@property (nonatomic, assign) float angle;
@property (nonatomic, strong) UtilityModelManager *modelManager;
@property (nonatomic, strong) UtilityModel *boatModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.9f,
                                                         0.9f,
                                                         0.9f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    
    // Set initial point of view
    self.eyePosition = GLKVector3Make(0.0f, 3.0f, 3.0f);
    self.lookAtPosition = GLKVector3Make(0.0f, 0.0f, 0.0f);
    self.upVector = GLKVector3Make(0.0f, 1.0f, 0.0f);
    
    // Load cubeMap texture
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"skybox0" ofType:@"png"];
    NSAssert(nil != path, @"path to skybox image not found");
    NSError *error = nil;
    self.textureInfo = [GLKTextureLoader cubeMapWithContentsOfFile:path options:nil error:&error];
    
    // Create and configure skybox
    self.skyboxEffect = [[AGLKSkyboxEffect alloc] init];
    self.skyboxEffect.textureCubeMap.name = self.textureInfo.name;
    self.skyboxEffect.textureCubeMap.target = self.textureInfo.target;
    self.skyboxEffect.xSize = 6.0f;
    self.skyboxEffect.ySize = 6.0f;
    self.skyboxEffect.zSize = 6.0f;
    
    // The model manager loads models and sends the data to GPU.
    // Each loaded model can be accessed by name.
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"boat" ofType:@"modelplist"];
    self.modelManager = [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    
    // Load models used to draw the scene
    self.boatModel = [self.modelManager modelNamed:@"boat"];
    NSAssert(nil != self.boatModel, @"Failed to load boat model");
    
    // Cull back faces: Important! Many Sketchup models have back faces that cause Z fighting if back faces are not culled.
    [((AGLKContext *)view.context) enable:GL_CULL_FACE];
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
}

// Configure self.baseEffect's projection and modelview matrix for cinematic orbit around ship model.
-(void)preparePointOfViewWithAspectRatio:(GLfloat)aspectRatio
{
    // Do this here insteades of -viewDidLoad because we don't yet know aspectRatio in -viewDidLoad
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f), aspectRatio, 0.1f, 20.0f);
    
    self.baseEffect.transform.modelviewMatrix =
    GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z,
                         self.lookAtPosition.x, self.lookAtPosition.y, self.lookAtPosition.z,
                         self.upVector.x, self.upVector.y, self.upVector.z);
    
    // Orbit slowly around ship model just to see the scene change
    self.angle += 0.01f;
    self.eyePosition = GLKVector3Make(3.0f * sinf(self.angle), 3.0f, 3.0f * cosf(self.angle));
    
    // Pitch up and down slowly to marvel at the sky and water
    self.lookAtPosition = GLKVector3Make(0.0f, 1.5f + 3.0f * sinf(0.3f * self.angle), 0.0f);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    
    // Clear back frame buffer colors (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Configure the point of view including animation
    [self preparePointOfViewWithAspectRatio:aspectRatio];
    
    // Set light position after change to point of view so that light uses correct coordinate system.
    self.baseEffect.light0.position = GLKVector4Make(0.4f,
                                                     0.4f,
                                                     -0.3f,
                                                     0.0f);// Directional light
    
    // Draw skybox centered on eye position
    self.skyboxEffect.center = self.eyePosition;
    self.skyboxEffect.transform.projectionMatrix = self.baseEffect.transform.projectionMatrix;
    self.skyboxEffect.transform.modelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    [self.skyboxEffect prepareToDraw];
    glDepthMask(false);
    [self.skyboxEffect draw];
    glBindVertexArrayOES(0);
    
    // Draw boat model
    [self.modelManager prepareToDraw];
    [self.baseEffect prepareToDraw];
    glDepthMask(true);
    [self.boatModel draw];
    
#ifdef DEBUG
    {
        // Report any errors
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

// This method is called automatically and allows all standard device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation !=
            UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
