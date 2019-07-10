//
//  ViewController.m
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "UtilityModel+viewAdditions.h"
#import "UtilityModelManager.h"
#import "UtilityTextureInfo.h"
#import "AGLKContext.h"

@interface ViewController ()
{
    NSMutableArray *cars;
}

@property (nonatomic, strong) UtilityModelManager *modelManager;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) UtilityModel *carModel;
@property (nonatomic, strong) UtilityModel *rinkModelFloor;
@property (nonatomic, strong) UtilityModel *rinkModelWalls;
@property (nonatomic, assign) AGLKAxisAllignedBoundingBox rinkBoundingBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create an array to store cars
    cars = [[NSMutableArray alloc] init];
    
    // Verify the type of view created automatically by the Interface Builder storyboard.
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current andenable depth testing
    [AGLKContext setCurrentContext:view.context];
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    
    // Create a base effect that provides standard OpenGL ES 2.0 shading language programs and set constants to be used for all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
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
    self.baseEffect.light0.position = GLKVector4Make(1.0f,
                                                     0.8f,
                                                     0.4f,
                                                     0.0f);// Directional light
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    
    // The model manager loads models and sends the data to GPU.
    // Each loaded model can be accessed by name.
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"bumper" ofType:@"modelplist"];
    self.modelManager = [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    
    // Loads models used to draw the scene
    self.carModel = [self.modelManager modelNamed:@"bumperCar"];
    NSAssert(nil != self.carModel,
             @"Failed to load car model");
    self.rinkModelFloor = [self.modelManager modelNamed:@"bumperRinkFloor"];
    NSAssert(nil != self.rinkModelFloor,
             @"Failed to load rink floor model");
    self.rinkModelWalls = [self.modelManager modelNamed:@"bumperRinkWalls"];
    NSAssert(nil != self.rinkModelWalls,
             @"Failed to load rink walls model");
    
    // Remember the rink bounding box for future collision detection with cars
    self.rinkBoundingBox = self.rinkModelFloor.axisAlignedBoundingBox;
    NSAssert(0 < (self.rinkBoundingBox.max.x -
                  self.rinkBoundingBox.min.x) &&
             0 < (self.rinkBoundingBox.max.z -
                  self.rinkBoundingBox.min.z),
             @"Rink has no area");
    
    // Create and add some cars to the simulation. The number of cars, colors and velocities and arbitrary.
    [cars addObject:[[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(1.0f, 0.0f, 1.0f) velocity:GLKVector3Make(1.5f, 0.0f, 1.5f) color:GLKVector4Make(0.0f, 0.5f, 0.0f, 1.0f)]];
    [cars addObject:[[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(-1.0f, 0.0f, 1.0f) velocity:GLKVector3Make(-1.5f, 0.0f, 1.5f) color:GLKVector4Make(0.5f, 0.5f, 0.0f, 1.0f)]];
    [cars addObject:[[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(1.0f, 0.0f, -1.0f) velocity:GLKVector3Make(-1.5f, 0, -1.5f) color:GLKVector4Make(0.5f, 0.0f, 0.0f, 1.0f)]];
    [cars addObject:[[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(2.0f, 0.0f, -2.0f) velocity:GLKVector3Make(-1.5f, 0.0f, -0.5f) color:GLKVector4Make(0.3f, 0.0f, 0.3f, 1.0f)]];
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulate rink visible
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(10.5f, 5.0f, 0.0f,// Eye position
                                                                     0.0f, 0.5f, 0.0f,//Look-at position
                                                                     0.0f, 1.0f, 0.0f);//Up direction
    self.baseEffect.texture2d0.name = self.modelManager.textureInfo.name;
    self.baseEffect.texture2d0.target = self.modelManager.textureInfo.target;
}

// This method is called automatically at the update rate of the receiver(default 30 Hz). This methos is implemented to call each car's -updateWithCars:method to enable simulated collision detection and car behavior.
-(void)update
{
    // Update the cars
    [cars makeObjectsPerformSelector:@selector(updateWithController:) withObject:self];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing) and depth buffer
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Cull back faces: Important! many Sketchup models have back faces that cause Z fighting if back faces are not called
    [((AGLKContext *)view.context) enable:GL_CULL_FACE];
    
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35.0f), aspectRatio, 4.0f, 20.0f);
    
    [self.modelManager prepareToDraw];
    [self.baseEffect prepareToDraw];
    
    // Draw the rink
    [self.rinkModelFloor draw];
    [self.rinkModelWalls draw];
    
    // Draw the cars
    [cars makeObjectsPerformSelector:@selector(drawWithBaseEffect:) withObject:self.baseEffect];
}

// This method is called automatically and allows all standard device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation !=
            UIInterfaceOrientationPortraitUpsideDown &&
            interfaceOrientation !=
            UIInterfaceOrientationPortrait);
}

-(NSArray *)cars
{
    return cars;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
