//
//  ViewController.m
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "UtilityModelManager.h"
#import "UtilityModel+viewAdditions.h"
#import "UtilityModel+skinning.h"
#import "UtilityModelManager+skinning.h"
#import "UtilityJoint.h"
#import "UtilityArmatureBaseEffect.h"
#import "AGLKContext.h"

@interface ViewController ()

@property (nonatomic, strong) UtilityModelManager *modelManager;
@property (nonatomic, strong) UtilityArmatureBaseEffect *baseEffect;
@property (nonatomic, strong) UtilityModel *bone0;
@property (nonatomic, strong) UtilityModel *bone1;
@property (nonatomic, strong) UtilityModel *bone2;
@property (nonatomic, assign) float joint0AngleRadians;
@property (nonatomic, assign) float joint1AngleRadians;
@property (nonatomic, assign) float joint2AngleRadians;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    //Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current andenable depth testing
    [AGLKContext setCurrentContext:view.context];
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    
    // Create a base effect that provides standard OpenGL ES 2.0 shading language programs and set constants to be used for all subsequent rendering
    self.baseEffect = [[UtilityArmatureBaseEffect alloc] init];
    
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.7f,
                                                         0.7f,
                                                         0.7f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    self.baseEffect.light0Position = GLKVector4Make(1.0f,
                                                    0.8f,
                                                    0.4f,
                                                    0.0f);// Directional light
    
    // Set the background color
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    
    // The model manager loads models and sends the data to GPU.
    // Each loaded model can be accessed by name.
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"armature" ofType:@"modelplist"];
    if (modelsPath) {
        self.modelManager = [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    }
    
    // Load models used to draw the utility
    self.bone0 = [self.modelManager modelNamed:@"bone0"];
    NSAssert(nil != self.bone0,
             @"Failed to load bone0 model");
    [self.bone0 assignJoint:0];
    
    self.bone1 = [self.modelManager modelNamed:@"bone1"];
    NSAssert(nil != self.bone1,
             @"Failed to load bone1 model");
    [self.bone1 assignJoint:1];
    
    self.bone2 = [self.modelManager modelNamed:@"bone2"];
    NSAssert(nil != self.bone2, @"Failed to load bone2 mode");
    [self.bone2 assignJoint:2];
    
    // Create collection of joints
    UtilityJoint *bone0Joint = [[UtilityJoint alloc] initWithDisplacement:GLKVector3Make(0, 0, 0) parent:nil];
    float bone0Length = self.bone0.axisAlignedBoundingBox.max.y - self.bone0.axisAlignedBoundingBox.min.y;
    UtilityJoint *bone1Joint = [[UtilityJoint alloc] initWithDisplacement:GLKVector3Make(0, bone0Length, 0) parent:bone0Joint];
    float bone1Length = self.bone1.axisAlignedBoundingBox.max.y - self.bone1.axisAlignedBoundingBox.min.y;
    UtilityJoint *bone2Joint = [[UtilityJoint alloc] initWithDisplacement:GLKVector3Make(0, bone1Length, 0) parent:bone1Joint];
    
    self.baseEffect.jointsArray = @[bone0Joint, bone1Joint, bone2Joint];
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulated rink visible
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(5.0f, 10.0f, 15.0f, 0.0f, 2.0f, 0.0f, 0.0f, 1.0f, 0.0f);
    
    // Start armature joints in default positions
    [self setJoint0AngleRadians:0];
    [self setJoint1AngleRadians:0];
    [self setJoint2AngleRadians:0];
}

// This method is called automatically at the update rate of the receiver (default 30 HZ)
-(void)update
{
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing) and depth buffer
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Cull back faces:Important! Many sketchup models have back faces that cause Z fighting if back faces are not culled.
    [((AGLKContext *)view.context) enable:GL_CULL_FACE];
    
    // Calculate the aspect ratio for the Utility and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35.0f), aspectRatio, 4.0f, 20.0f);
    
    [self.modelManager prepareToDrawWithJointInfluence];
    [self.baseEffect prepareToDrawArmature];
    
    // Draw the bones
    [self.bone0 draw];
    [self.bone1 draw];
    [self.bone2 draw];
    
#ifdef DEBUG
    {
        // Report any errors
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x",error);
        }
    }
#endif
}

// This method is called automatically and allows all standard device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation !=
                UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

//
-(void)setJoint0AngleRadians:(float)joint0AngleRadians
{
    _joint0AngleRadians = joint0AngleRadians;
    GLKMatrix4 rotateZMatrix = GLKMatrix4MakeRotation(joint0AngleRadians * M_PI * 0.5, 0, 0, 1);
    [(UtilityJoint *)[self.baseEffect.jointsArray objectAtIndex:0] setMatrix:rotateZMatrix];
}

//
-(void)setJoint1AngleRadians:(float)joint1AngleRadians
{
    _joint1AngleRadians = joint1AngleRadians;
    GLKMatrix4 rotateZMatrix = GLKMatrix4MakeRotation(joint1AngleRadians * M_PI * 0.5, 0, 0, 1);
    [(UtilityJoint *)[self.baseEffect.jointsArray objectAtIndex:1] setMatrix:rotateZMatrix];
}

//
-(void)setJoint2AngleRadians:(float)joint2AngleRadians
{
    _joint2AngleRadians = joint2AngleRadians;
    GLKMatrix4 rotateZMatrix = GLKMatrix4MakeRotation(joint2AngleRadians * M_PI * 0.5, 0, 0, 1);
    [(UtilityJoint *)[self.baseEffect.jointsArray objectAtIndex:2] setMatrix:rotateZMatrix];
}

- (IBAction)takeAngle0From:(UISlider *)sender {
    [self setJoint0AngleRadians:sender.value];
}

- (IBAction)takeAngle1From:(UISlider *)sender {
    [self setJoint1AngleRadians:sender.value];
}

- (IBAction)takeAngle2From:(UISlider *)sender {
    [self setJoint2AngleRadians:sender.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
