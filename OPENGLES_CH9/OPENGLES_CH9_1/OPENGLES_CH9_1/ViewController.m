//
//  ViewController.m
//  OPENGLES_CH9_1
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "UtilityModelManager.h"
#import "UtilityModel+viewAdditions.h"
#import "AGLKContext.h"
#import "AGLKFrustum.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UtilityModelManager *modelManager;
@property (nonatomic, strong) UtilityModel *model;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, assign) float filteredFPS;
@property (nonatomic, assign) AGLKFrustum frustum;
@property (nonatomic, assign) BOOL orientationDidChange;
@property (nonatomic, assign) BOOL shouldCull;
@property (nonatomic, assign) float yawAngleRad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Cull by default
    self.shouldCull = YES;
    
    // Verify the type of view created automatically by Interface Builder storyboard.
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    [(AGLKContext *)view.context enable:GL_DEPTH_TEST];
    [(AGLKContext *)view.context enable:GL_CULL_FACE];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.7f,
                                                         0.7f,
                                                         0.7f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    self.baseEffect.light0.position = GLKVector4Make(1.0f,
                                                     0.8f,
                                                     0.4f,
                                                     0.0f);// Directional light
    
    // Set back background color
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    
    // The model manager loads models and sends the data to GPU.
    // Each loaded model can be accessed by name.
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"starships" ofType:@"modelplist"];
    if (modelsPath) {
        self.modelManager = [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    }
    
    // Load models used to draw the scene
    self.model = [self.modelManager modelNamed:@"starship2"];
    NSAssert(nil != self.model,@"Failed to load model");
}

-(void)update
{
    const NSTimeInterval elapsedTime = [self timeSinceLastUpdate];
    if (0.0 < elapsedTime) {
        const float unfilteredFPS = 1.0f/elapsedTime;
        // add part of the difference betweeen current filtered FPS unfilteredFPS (simple low pass filter)
        self.filteredFPS += 0.2f * (unfilteredFPS - self.filteredFPS);
    }
    self.fpsField.text = [NSString stringWithFormat:@"%03.1f FPS",self.filteredFPS];
}

// Update the receiver's baseEffect modelview and projection matrices based on device orientation.
-(void)calculateMatricesAndFrustumInView:(GLKView *)view
{
    if (self.orientationDidChange || !AGLKFrustumHasDimention(&_frustum)) {
        // Calculate the aspect ratio for the scene and setup an arbitrary perspcetive projection
        const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
        const GLfloat fieldOfViewDeg = 7.0f;
        const GLfloat nearDistance = 1.0f;
        const GLfloat farDistance = 10000.0f;
        const GLfloat fieldOfViewRad = GLKMathDegreesToRadians(fieldOfViewDeg);
        
        // Initialize the frustum with same perspective parameters used by GLKMatrix4MakePerspective()
        self.frustum = AGLKFrustumMakeFrustumWithParameters(fieldOfViewRad,
                                                            aspectRatio,
                                                            nearDistance,
                                                            farDistance);
       
        // Set the base effect's projection matrix to match frustum
        self.baseEffect.transform.projectionMatrix = AGLKFrustumMakePerspective(&_frustum);
    }
    
    // Use motion capture if available to pan around the scene demonstrating continuously changing  viewing frustum
    CMMotionManager *motionManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] motionManager];
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    
    if (deviceMotion) {
        // Use high resolution device motion capture
        self.yawAngleRad = deviceMotion.attitude.yaw;
    } else {
        // Use arbitrary rotation rate just to animate scene
        self.yawAngleRad = 0.1f * [self timeSinceLastResume];
    }
    
    // Use reasonable eye position and up position
    static const GLKVector3 eyePosition = {
        0.0f, 5.0f, 0.0f
    };
    static const GLKVector3 upDirection = {
        0.0f, 1.0f, 0.0f
    };
    
    // Calculate current look-at position
    const GLKVector3 lookAtPosition = {
        100.0f * sinf(self.yawAngleRad),
        0.0f,
        100.0f * cosf(self.yawAngleRad)
    };
    
    // Configure the frustum field of view with same parameters used by GLKMatrix4MakeLookAt()
    AGLKFrustumSetPositionAndDirection(&_frustum,
                                       eyePosition,
                                       lookAtPosition,
                                       upDirection);
    
    // Set the base effect's modelview matrix to match frustum
    self.baseEffect.transform.modelviewMatrix = AGLKFrustumMakeModelview(&_frustum);
}

-(void)drawModels
{
    const float modelRadius = 7.33f; // used to cull models
    self.baseEffect.texture2d0.name = self.modelManager.textureInfo.name;
    self.baseEffect.texture2d0.target = self.modelManager.textureInfo.target;
    
    [self.modelManager prepareToDraw];
    
    // Draw an arbitary large number of models
    for (NSInteger i = -4; i < 5; i++) {
        for (NSInteger j = -4; j < 5; j++) {
            const GLKVector3 modelPosition ={
                -100.0f + 150.0f * i,
                0.0f,
                -100.0f + 150.0f * j};
            if (!self.shouldCull || AGLKFrustumOut != AGLKFrustumCompareSphere(&_frustum, modelPosition, modelRadius)) {
                // Save the current matrix
                GLKMatrix4 savedMatrix = self.baseEffect.transform.modelviewMatrix;
                
                // Translate to the model position
                self.baseEffect.transform.modelviewMatrix =
                GLKMatrix4Translate(savedMatrix,
                                    modelPosition.x,
                                    modelPosition.y,
                                    modelPosition.z);
                [self.baseEffect prepareToDraw];
                
                // Draw the model
                [self.model draw];
                
                // Restore the saved matrix
                self.baseEffect.transform.modelviewMatrix = savedMatrix;
            }
        }
    }
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing) and depth buffer
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    [self calculateMatricesAndFrustumInView:view];
    [self drawModels];
    
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
    BOOL result = NO;
    
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPhone)
    {
        result = (interfaceOrientation !=
                  UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        result = YES;
    }
    
    self.orientationDidChange = result;
    
    return result;
}

// This action method is called by a user interface switch configured in Instance Builder.
- (IBAction)takeShouldCullFrom:(UISwitch *)sender {
    self.shouldCull = [sender isOn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
