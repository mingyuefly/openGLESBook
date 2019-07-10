//
//  ViewController.m
//  OPENGLES_CH8_4
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "UtilityBillboardManager+viewAdditions.h"
#import "UtilityBillboard.h"
#import "UtilityModelManager.h"
#import "UtilityModel+viewAdditions.h"

@interface ViewController ()
{
    
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) UtilityBillboardManager *billboardManager;
@property (nonatomic, assign, readwrite) GLKVector3 eyePosition;
@property (nonatomic, assign) GLKVector3 lookAtPosition;
@property (nonatomic, assign) GLKVector3 upVector;
@property (nonatomic, assign) float angle;
@property (nonatomic, strong) UtilityModelManager *modelManager;
@property (nonatomic, strong) UtilityModel *parkModel;
@property (nonatomic, strong) UtilityModel *cylinderModel;

-(void)addBillboardTrees;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    // Use high resolution depth buffer
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    NSString *modelsPath = [[NSBundle mainBundle] pathForResource:@"park" ofType:@"modelplist"];
    self.modelManager = [[UtilityModelManager alloc] initWithModelPath:modelsPath];
    
    // Load models used to draw the scene
    self.parkModel = [self.modelManager modelNamed:@"park"];
    NSAssert(nil != self.parkModel, @"Failed to load park model");
    self.cylinderModel = [self.modelManager modelNamed:@"cylinder"];
    NSAssert(nil != self.cylinderModel, @"Failed to load cylinder model");
    
    // Add billboards to demo
    [self addBillboardTrees];
    
    // Set initial point of view
    self.eyePosition = GLKVector3Make(15, 8, 15);
    self.lookAtPosition = GLKVector3Make(0.0f, 0.0f, 0.0f);
    self.upVector = GLKVector3Make(0.0f, 1.0f, 0.0f);
    
    // Set other persistent context state
    [(AGLKContext *)view.context setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];
    [(AGLKContext *)view.context enable:GL_DEPTH_TEST];
    [(AGLKContext *)view.context enable:GL_BLEND];
    [(AGLKContext *)view.context setBlendSourceFunction:GL_SRC_ALPHA
                                    destinationFunction:GL_ONE_MINUS_SRC_ALPHA];
    
    // Cull back faces: Important! Many Sketchup models have back faces that cause Z fighting if back faces are not culled
    [((AGLKContext *)view.context) enable:GL_CULL_FACE];
    
    // Create and configure base effect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.8f,
                                                         0.8f,
                                                         0.8f,
                                                         1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.9f,
                                                         0.9f,
                                                         0.9f,
                                                         1.0f);
    self.baseEffect.texture2d0.name = self.modelManager.textureInfo.name;
    self.baseEffect.texture2d0.target = self.modelManager.textureInfo.target;
}

// Configure self.baseEffect's projection and model-view matrix for cinematic orbit around ship model.
-(void)preparePointOfViewWithAspectRatio:(GLfloat)aspectRatio
{
    // Do this here instead of -viewDidLoad because we don't yet know aspectRatio in -viewDidLoad.
    self.baseEffect.transform.projectionMatrix =
    GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f),
                              aspectRatio,
                              0.5f,
                              200.0f);
    self.baseEffect.transform.modelviewMatrix =
    GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z,
                         self.lookAtPosition.x, self.lookAtPosition.y, self.lookAtPosition.z,
                         self.upVector.x, self.upVector.y, self.upVector.z);
    self.angle += 0.01;
    self.eyePosition = GLKVector3Make(15.0f * sinf(self.angle),
                                      18.0f + 5.0f * sinf(0.3f * self.angle),
                                      15.0f * cosf(self.angle));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    
    // Clear back frame buffer colors (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Configure the point of view including animation
    [self preparePointOfViewWithAspectRatio:aspectRatio];
    
    // Set light position after change to point of view so that light uses correct coordinate system.
    self.baseEffect.light0.position = GLKVector4Make(0.4f,
                                                     0.4f,
                                                     0.2f,
                                                     0.0f);// Directional light
    [self.modelManager prepareToDraw];
    [self.parkModel draw];
    
    const GLKMatrix4 savedModelview = self.baseEffect.transform.modelviewMatrix;
    const GLKMatrix4 translationModleview = GLKMatrix4Translate(savedModelview,
                                                                -5.0f,
                                                                0.0f,
                                                                -5.0f);
    
    if (self.billboardManager.shouldRenderSpherical) {
        // Translate to cylinder position and mutiply transpose of rotation components from modelview
        GLKMatrix4 rotationModelview = translationModleview;
        rotationModelview.m30 = 0.0f;
        rotationModelview.m31 = 0.0f;
        rotationModelview.m32 = 0.0f;
        rotationModelview = GLKMatrix4Transpose(rotationModelview);
        self.baseEffect.transform.modelviewMatrix = GLKMatrix4Multiply(translationModleview, rotationModelview);
        [self.baseEffect prepareToDraw];
        [self.cylinderModel draw];
    } else {
        // Translate to cylinder position
        self.baseEffect.transform.modelviewMatrix = translationModleview;
        [self.baseEffect prepareToDraw];
        [self.cylinderModel draw];
    }
    
    // Restore modelview matrix
    self.baseEffect.transform.modelviewMatrix = savedModelview;
    [self.baseEffect prepareToDraw];
    
    const GLKVector3 lookDirection = GLKVector3Subtract(self.lookAtPosition, self.eyePosition);
    [self.billboardManager updateWithEyePosition:self.eyePosition lookDirection:lookDirection];
    [self.billboardManager drawWithEyePosition:self.eyePosition lookDirection:lookDirection upVector:self.upVector];
    
    {
        // log any errors
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
}

// This method is called automatically and allows all standard device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation !=
            UIInterfaceOrientationPortraitUpsideDown);
}

// Add billboards with translucent textures that look like trees. The selection of textures is arbitrarily chosen to provide variety in the rendered scene. The placement of billboards corresponds with the "park" model used in the example.
-(void)addBillboardTrees
{
    if (!self.billboardManager) {
        self.billboardManager = [[UtilityBillboardManager alloc] init];
    }
    for (int j = -4; j < 4; j++) {
        for (int i = -4; i < 4; i++) {
            const NSInteger treeIndex = random() % 2;
            const GLfloat mintextureT = treeIndex * 0.25f;
            
            [self.billboardManager addBillboardAtPosition:GLKVector3Make(i * -10.0f - 5.0f,
                                                                         0.0f,
                                                                         j * -10.0f - 5.0f)
                                                     size:GLKVector2Make(8.0f,
                                                                         8.0f)
                                         minTextrueCoords:GLKVector2Make(3.0f/8.0f,
                                                                         1.0f - mintextureT)
                                         maxTextureCoords:GLKVector2Make(7.0f/8.0f,
                                                                         1.0f - (mintextureT + 0.25f))];
        }
    }
}

- (IBAction)takeShouldRenderSpherical:(UISwitch *)sender {
    self.billboardManager.shouldRenderSpherical = sender.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
