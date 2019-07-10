//
//  ViewController.m
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TETerrain+viewAdditions.h"
#import "TEModelPlacement.h"
#import "UtilityModel.h"
#import "UtilityModelManager.h"
#import "UtilityTerrainEffect.h"
#import "UtilityPickTerrainEffect.h"
//#import "UtilityCamera.h"
#import "UtilityModelEffect.h"

@class UtilityTextureInfo;

@interface ViewController ()
{
    float angle;        // look direction angle about Y axis
    float targetAngle;  // Target look direction angle about Y axis
}

//@property (nonatomic, strong, readwrite) UtilityTerrainEffect *terrainEffect;
@property (nonatomic, strong, readwrite) UtilityPickTerrainEffect *pickTerrainEffect;
@property (nonatomic, strong, readwrite) UtilityModelEffect *modelEffect;
@property (nonatomic, strong, readwrite) UtilityCamera *camera;
@property (nonatomic, strong, readwrite) NSArray *tiles;
@property (nonatomic, assign, readwrite) GLfloat thirdPersonOffset;
@property (nonatomic, assign, readwrite) GLfloat pitchOffset;
@property (nonatomic, assign, readwrite) BOOL isAnimating;
@property (nonatomic, assign, readwrite) GLKVector3 referencePosition;
@property (nonatomic, assign, readwrite) GLKVector3 targetPosition;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) float filteredFPS;

@end

// Default frustum projection parameters
static const GLfloat DefaultFieldOfView = (M_PI / 180.0f) * 45.0f;
static const GLfloat DefaultNearLimit = 0.5f;
static const GLfloat DefaultFarLimit = 5000.0f;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glView = (GLKView *)self.view;
    NSAssert([glView isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glView.context];
    
    // Try to render as fast as possible
    self.preferredFramesPerSecond = 60;
    
    // init GL stuff here
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Camera used for placed blocks on game board
    self.camara = [[UtilityCamera alloc] init];
    self.camara.delegate = self;
    
    self.referencePosition = GLKVector3Make(400.0f,
                                            0.0f,
                                            400.0f);
    
    self.targetPosition = self.referencePosition;
    
    targetAngle = angle = 1.0f * M_PI / 4.0f; //Arbitrary angle
    [self.camara setPostion:self.referencePosition
             lookAtPosition:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
    // Cache tiles in a property for future drawing or never change
    self.terrainEffect = [[UtilityTerrainEffect alloc] initWithTerrain:[self.dataSource terrain]];
    self.terrainEffect.globalAmbientLightColor = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
    TETerrain *terrain = [[self dataSource] terrain];
    
    self.terrainEffect.lightAndWeightsTextureInfo = terrain.lightAndWeightsTextureInfo;
    self.terrainEffect.detailTextureInfo0 = terrain.detailTextureInfo0;
    self.terrainEffect.detailTextureInfo1 = terrain.detailTextureInfo1;
    self.terrainEffect.detailTextureInfo2 = terrain.detailTextureInfo2;
    self.terrainEffect.detailTextureInfo3 = terrain.detailTextureInfo3;
    
    // Create modelEffect and configure properties that seldom or never change
    self.modelEffect = [[UtilityModelEffect alloc] init];
    self.modelEffect.globalAmbientLightColor = self.terrainEffect.globalAmbientLightColor;
    self.modelEffect.diffuseLightDirection =
    GLKVector3Normalize(GLKVector3Make(terrain.lightDirectionX,
                                       terrain.lightDirectionY,
                                       terrain.lightDirectionZ));
    
    // Create pickTerrainEffect and configure properties that seldom or never change
    self.pickTerrainEffect = [[UtilityPickTerrainEffect alloc] initWithTerrain:[self.dataSource terrain]];
    
    // Pre-warm GPU by downloading model data before it's needed
    [[self.dataSource modelManager] prepareToDraw];
    
#ifdef DEBUG
    {
        // Report any errors
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
    
    {
        // Create a tap recognizer and add it to the view.
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self.view addGestureRecognizer:recognizer];
        self.tapRecognizer = recognizer;
        recognizer.delegate = self;
    }
    
    {
        // Create a pan recognizer and add it to the view.
        UIPanGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        [self.view addGestureRecognizer:recognizer];
        self.panRecognizer = recognizer;
        recognizer.delegate = self;
    }
}

//
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

#pragma mark - GLKViewDelegate
-(GLKMatrix3)matrixForScaleFactor:(float)aFactor
{
    const float constWidthMeters = self.dataSource.terrain.widthMeters;
    const float constLengthMeters = self.dataSource.terrain.lengthMeters;
    const float constMetersPerUnit = self.dataSource.terrain.metersPerUnit;
    
    NSAssert(0 < constWidthMeters, @"Invalid terrain.widthMeters");
    NSAssert(0 < constLengthMeters, @"Invalid terrain.lengthMeters");
    NSAssert(0 < constMetersPerUnit, @"Invalid terrain.metersPerUnit");
    
    float widthScalefactor = self.dataSource.terrain.detailTextureScale0 / constMetersPerUnit;
    widthScalefactor = MAX(widthScalefactor, 1.0f / constWidthMeters);
    float lengthScalefactor = self.dataSource.terrain.detailTextureScale0 / constMetersPerUnit;
    lengthScalefactor = MAX(lengthScalefactor, 1.0f / constLengthMeters);
    
    return GLKMatrix3MakeScale(widthScalefactor,
                               1.0f,
                               lengthScalefactor);
}

//
-(void)updateDetailTextureMatrices
{
    self.terrainEffect.textureMatrix0 = [self matrixForScaleFactor:self.dataSource.terrain.detailTextureScale0];
    self.terrainEffect.textureMatrix1 = [self matrixForScaleFactor:self.dataSource.terrain.detailTextureScale1];
    self.terrainEffect.textureMatrix2 = [self matrixForScaleFactor:self.dataSource.terrain.detailTextureScale2];
    self.terrainEffect.textureMatrix3 = [self matrixForScaleFactor:self.dataSource.terrain.detailTextureScale3];
}

//
-(void)update{
    GLKVector3 direction = GLKVector3Subtract(self.targetPosition, self.referencePosition);
    direction.y = 0.0f;
    const float distance = GLKVector3Length(direction);
    
    if (0.01f >= distance && angle == targetAngle) {
        // No need to do anything
    } else {
        if (1.0f >= distance) {
            self.referencePosition = self.targetPosition;
        } else {
            direction.x /= distance;
            direction.z /= distance;
            self.referencePosition = GLKVector3Add(self.referencePosition, direction);
        }
        
        [self.camara moveBy:direction];
        self.referencePosition = [self.camara position];
        angle = targetAngle;
    }
    
    const NSTimeInterval elapsedTime = [self timeSinceLastUpdate];
    if (0.0f < elapsedTime) {
        const float unfilteredFPS = 1.0f / elapsedTime;
        
        // add part of the difference between current filtered FPS and unfilteredFPS(simple low pass filter)
        self.filteredFPS += 0.2f * (unfilteredFPS - self.filteredFPS);
    }
    
    self.fpsField.text = [NSString stringWithFormat:@"%03.1f FPS", self.filteredFPS];
}

//
-(void)drawTerrainAndModels
{
    TETerrain *terrain = [[self dataSource] terrain];
    
    if (!self.tiles) {
        // Cache tiles
        self.tiles = terrain.tiles;
    }
    
    // The terrain is opaque, so there is no need to blend.
    glDisable(GL_BLEND);
    [terrain drawTerrainWithinTiles:self.tiles
                         withCamera:self.camara
                      terrainEffect:self.terrainEffect];
    
    // Assume subsequent for texture and diffuse lighting
    glEnable(GL_BLEND);
    
    // Configure modelEffect for texture and diffuse lighting
    self.modelEffect.texture2D = [self.dataSource.modelManager textureInfo];
    self.modelEffect.projectionMatrix = self.camara.projectionMatrix;
    self.modelEffect.modelviewMatrix = self.camara.modelviewMatrix;
    
    [self.modelEffect prepareToDraw];
    [self.dataSource.modelManager prepareToDraw];
    
    [terrain drawModelsWithinTiles:self.tiles
                        withCamera:self.camara
                       modelEffect:self.modelEffect
                      modelManager:self.dataSource.modelManager];
}

//
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat width = [view drawableWidth];
    const GLfloat height = [view drawableHeight];
    
    NSParameterAssert(0 < height);
    const GLfloat aspectRatio = width / height;
    const GLfloat angleRad = DefaultFieldOfView;
    
    // Configure projection and viewing/clipping volume
    [self.camara configurePerspectiveFieldOfViewRad:angleRad
                                        aspectRatio:aspectRatio
                                               near:DefaultNearLimit
                                                far:DefaultFarLimit];
    [self updateDetailTextureMatrices];
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    [self drawTerrainAndModels];
    
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

#pragma mark - Camara delegate
static const GLfloat TEHeadHeightMeters = 2.0f;

// Camera delegate method
-(BOOL)camera:(UtilityCamera *)aCamera willChangeEyePosition:(GLKVector3 *)eyePositionPtr
lookAtPosition:(GLKVector3 *)lookAtPositionPtr
{
    TETerrain *terrain = [self.dataSource terrain];
    const float metersPerUnit = terrain.metersPerUnit;
    
    // Contrain referencePosition to terrain and keep it above terrain height
    _referencePosition.x = MIN(MAX(2, self.referencePosition.x), terrain.widthMeters - 2);
    _referencePosition.z = MIN(MAX(2, self.referencePosition.z), terrain.lengthMeters - 2);
    
    const float heightAtReferencePosition = [terrain calculatedHeightAtXPosMeters:self.referencePosition.x zPosMeters:self.referencePosition.y surfaceNormal:NULL];
    _referencePosition.y = TEHeadHeightMeters + heightAtReferencePosition;
    
    // Ignore passed lookAt position and look in angle direction
    GLKVector3 lookAtPosition =
    GLKVector3Make(self.referencePosition.x + cosf(angle) * metersPerUnit,
                   0.0f,
                   self.referencePosition.z + sinf(angle) * metersPerUnit);
    
    lookAtPosition.y = [terrain calculatedHeightAtXPosMeters:lookAtPosition.x zPosMeters:lookAtPosition.z surfaceNormal:NULL];
    lookAtPosition.y = MAX(lookAtPosition.y, self.referencePosition.y);
    lookAtPosition.y += self.pitchOffset;
    
    *lookAtPositionPtr = lookAtPosition;
    *eyePositionPtr = self.referencePosition;
    
    return YES;
}

#pragma mark - Responding to gestures
//
- (TEPickTerrainInfo)pickTerrainAndModelsAtViewLocation:(CGPoint)aViewLocation
{
    GLKView *glView = (GLKView *)self.view;
    NSAssert([glView isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    // Make the view's context curren
    [EAGLContext setCurrentContext:glView.context];
    
    TETerrain *terrain = [[self dataSource] terrain];
    if (!self.tiles) {
        // Cache tiles
        self.tiles = terrain.tiles;
    }
    
    [terrain prepareToPickTerrain:self.tiles withCamera:self.camara PickEffect:self.pickTerrainEffect];
    
    const GLfloat width = [glView drawableWidth];
    const GLfloat height = [glView drawableHeight];
    NSAssert(0 < width && 0 < height, @"Invalid drawble size");
    
    // Get info for picked location
    const GLKVector2 scaledProjectionPosition = {
        aViewLocation.x / width,
        aViewLocation.y / height
    };
    
    const TEPickTerrainInfo pickInfo = [self.pickTerrainEffect terrainInfoForProjectionPosition:scaledProjectionPosition];
    
    // Restore OpenGL state pickTerrainEffect changed
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glViewport(0, 0, width, height);
    
#ifdef DEBUG
    {
        // Report any errors
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
    
    //NSLog(@"{{%f, %f}, %d",
    //   pickInfo.position.x, pickInfo.position.y,
    //   (NSInteger)pickInfo.modelIndex);
    
    return pickInfo;
}

// This method is part of the UIGestureRecognizerDelegate protocol. This implemention accepts tap and pan gestures and ignores prevents all others
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch
{
    BOOL result = NO;
    if (gestureRecognizer == self.tapRecognizer || gestureRecognizer == self.panRecognizer) {
        result = YES;
    }
    return result;
}

// This method is called from a UIGestureRecognizer whenever the user taps a finger. This implemention interprets the tap location as the next target position for the camera.
-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    
    // Flip location for CG Y coordinate to GL coordinates conversion
    location.y = self.view.bounds.size.height - location.y;
    TEPickTerrainInfo pickInfo = [self pickTerrainAndModelsAtViewLocation:location];
    
    const float constMetersPerUnit = self.dataSource.terrain.metersPerUnit;
    if (0.0f < pickInfo.position.x && 0.0f < pickInfo.position.y) {
        self.targetPosition =
        GLKVector3Make(pickInfo.position.x * constMetersPerUnit,
                       0.0f,
                       pickInfo.position.y * constMetersPerUnit);
    }
}

// This method is called from a UIGestureRecognizer whenever the user swips a finger in a pan gesture. This implementation turns the camera point of view about the Y axis (yaw) and about the x axis (pitch).
-(void)handlePanFrom:(UIPanGestureRecognizer *)gestureRecogizer
{
    if ([gestureRecogizer state] == UIGestureRecognizerStateBegan || [gestureRecogizer state] == UIGestureRecognizerStateChanged) {
        CGPoint velocity = [gestureRecogizer velocityInView:self.view];
        
        targetAngle -= (velocity.x / self.view.bounds.size.width) * 0.1f;
        self.pitchOffset -= (velocity.y / self.view.bounds.size.height) * 0.5f;
        self.pitchOffset = MAX(MIN(5.0f, self.pitchOffset), -5.0f);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
