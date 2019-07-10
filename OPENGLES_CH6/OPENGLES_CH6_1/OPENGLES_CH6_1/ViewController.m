//
//  ViewController.m
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "SceneCarModel.h"
#import "SceneRinkModel.h"
#import "AGLKContext.h"

@interface ViewController ()
{
    NSMutableArray *cars;//Cars to simulate
}
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) SceneModel *carModel;
@property (nonatomic, strong) SceneModel *rinkModel;
@property (nonatomic, assign) BOOL shouldUseFirstPersonPOV;
@property (nonatomic, assign) GLfloat pointOfViewAnimationCountdown;
@property (nonatomic, assign) GLKVector3 eyePosition;
@property (nonatomic, assign) GLKVector3 lookAtPosition;
@property (nonatomic, assign) GLKVector3 targetEyePosition;
@property (nonatomic, assign) GLKVector3 targetLookAtPosition;
@property (nonatomic, assign, readwrite) SceneAxisAllignedBoundingBox rinkBoundingBox;

@end

@implementation ViewController

// Arbitrary constant chosen to prolong the "point of view" animation so that it's noticeable.
static const int SceneNumberOfPOVAnimationSeconds = 2.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create an array to store cars
    cars = [@[] mutableCopy];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Create an OpenGLES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.6f,
                                                         0.6f,
                                                         0.6f,
                                                         1.0f);
    self.baseEffect.light0.position = GLKVector4Make(
                                                     1.0f,
                                                     0.8f,
                                                     0.4f,
                                                     0.0f);
    // Set the backgound color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f,
                                                              0.0f,
                                                              0.0f,
                                                              1.0f);
    // Enable depth testing and blending with the frame buffer
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    [((AGLKContext *)view.context) enable:GL_BLEND];
    
    // Load models used to draw the scene
    self.carModel = [[SceneCarModel alloc] init];
    self.rinkModel = [[SceneRinkModel alloc] init];
    
    // Remember the rink bounding box for future collision detection with cars
    self.rinkBoundingBox = self.rinkModel.axisAlignedBoundingBox;
    NSAssert(0 < (self.rinkBoundingBox.max.x - self.rinkBoundingBox.min.x) && 0 < (self.rinkBoundingBox.max.z - self.rinkBoundingBox.min.z), @"Rink has no area");
    
    // Create and add some cars to the simulation. The number of cars, colors and velocities are arbitrary
    SceneCar *newCar = [[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(1.0f, 0.0f, 1.0f) velocity:GLKVector3Make(1.5f, 0.0f, 1.5f) color:GLKVector4Make(0.0f, 0.5f, 0.0f, 1.0f)];
    [cars addObject:newCar];
    
    newCar = [[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(-1.0f, 0.0f, 1.0f) velocity:GLKVector3Make(-1.5f, 0.0f, 1.5f) color:GLKVector4Make(0.5f, 0.5f, 0.0f, 1.0f)];
    [cars addObject:newCar];
    
    newCar = [[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(1.0f, 0.0f, -1.0f) velocity:GLKVector3Make(-1.5f, 0.0f, -0.5f) color:GLKVector4Make(0.5f, 0.0f, 0.0f, 1.0f)];
    [cars addObject:newCar];
    
    newCar = [[SceneCar alloc] initWithModel:self.carModel position:GLKVector3Make(2.0f, 0.0f, -2.0f) velocity:GLKVector3Make(-1.5f, 0.0f, -0.5f) color:GLKVector4Make(0.3f, 0.0f, 0.3f, 1.0f)];
    [cars addObject:newCar];
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulated rink visible
    self.eyePosition = GLKVector3Make(10.5f, 5.0f, 0.0f);
    self.lookAtPosition = GLKVector3Make(0.0f, 0.5f, 0.0f);
}

// This method must be called at least once before the receiver is drawn. This method updates the "target" eye position and look-at position based on the use's chosen point of view.
-(void)updatePointOfView
{
    if (!self.shouldUseFirstPersonPOV) {
        // Set the target point of view to arbitry "third person"
        // perspective
        self.eyePosition = GLKVector3Make(10.5f, 5.0f, 0.0f);
        self.lookAtPosition = GLKVector3Make(0.0f, 0.5f, 0.0f);
    } else {
        // Set the target point of view to a position within the last car and facing the direction of the car's motion.
        SceneCar *viewerCar = [cars lastObject];
        
        // Set the new target position up a bit from center of car
        self.targetEyePosition = GLKVector3Make(viewerCar.position.x, viewerCar.position.y + 0.45f, viewerCar.position.z);
        
        // Look from eye position in direction of motion
        self.targetLookAtPosition = GLKVector3Add(self.eyePosition, viewerCar.velocity);
    }
}

// This method is called automatically at the update rate of receiver (default 30 HZ). This method is implemented to recalculate the current eye and look-at positions to animate the point of view. This method also calls each car's -updateWithCars: method to enable simulated collision detection and car behavior.
-(void)update
{
    if (0 < self.pointOfViewAnimationCountdown) {
        self.pointOfViewAnimationCountdown -= self.timeSinceLastUpdate;
        
        // Update the current eye and look-at positions with slow filter so user can savor the POV animation
        self.eyePosition = SceneVector3SlowLowPassFilter(self.timeSinceLastUpdate, self.targetEyePosition, self.eyePosition);
        self.lookAtPosition = SceneVector3SlowLowPassFilter(self.timeSinceLastUpdate, self.targetLookAtPosition, self.lookAtPosition);
    } else {
        // Update the current eye and look-at positions with fast filter so POV stays close to car orientation but still has a little "bounce"
        self.eyePosition = SceneVector3FastLowPassFilter(self.timeSinceLastUpdate, self.targetEyePosition, self.eyePosition);
        self.lookAtPosition = SceneVector3FastLowPassFilter(self.timeSinceLastUpdate, self.targetLookAtPosition, self.lookAtPosition);
    }
    
    // Update the cars
    [cars makeObjectsPerformSelector:@selector(updateWithController:) withObject:self];
    
    // Update the target positions
    [self updatePointOfView];
}

// GLKView delegate method: Called by the view controller's view whenever Cocoa Touch asks the view controller's view to draw itself. (In this case, render into a frame buffer that shares memory with a Core Animation Layer)
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Make the light white
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    // Clear back frame buffer (erase previous drawing)
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35.0f), aspectRatio, 0.1f, 25.0f);
    
    // Set the modelview matrix to match current eye and look-at positions
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z, self.lookAtPosition.x, self.lookAtPosition.y, self.lookAtPosition.z, 0, 1, 0);
    
    // Draw the rink
    [self.baseEffect prepareToDraw];
    [self.rinkModel draw];
    
    // Draw the cars
    [cars makeObjectsPerformSelector:@selector(drawWithBaseEffect:) withObject:self.baseEffect];
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

-(NSArray *)cars
{
    return cars;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeShouldUseFirstPersonPOVFrom:(UISwitch *)sender {
    self.shouldUseFirstPersonPOV = [sender isOn];
    
    // Reset a counter that makes point of view animation
    // Last SceneNumberOfPOVAnimationFrames so animation is noticeable.
    self.pointOfViewAnimationCountdown = SceneNumberOfPOVAnimationSeconds;
}


@end
