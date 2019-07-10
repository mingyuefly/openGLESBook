//
//  ViewController.m
//  OPENGLES_CH5_4
//
//  Created by Gguomingyue on 2017/9/20.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "lowPolyAxesAndModels2.h"

// Forward declaration
static GLKMatrix4 SceneMatrixForTransform(SceneTransformtionSelector type, SceneTransformationAxisSelector axis, float value);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.4f,
                                                         0.4f,
                                                         0.4f,
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
    
    // Create vertex buffers containing vertices to draw
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(lowPolyAxesAndModels2Verts)/(3 * sizeof(GLfloat)) bytes:lowPolyAxesAndModels2Verts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(3 * sizeof(GLfloat)) numberOfVertices:sizeof(lowPolyAxesAndModels2Normals)/(3 * sizeof(GLfloat)) bytes:lowPolyAxesAndModels2Normals usage:GL_STATIC_DRAW];
    [(AGLKContext *)view.context enable:GL_DEPTH_TEST];
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeRotation(
                                                        GLKMathDegreesToRadians(30.0f),
                                                        1.0f,
                                                        0.0f,
                                                        0.0f);
    modelviewMatrix = GLKMatrix4Rotate(
                                       modelviewMatrix,
                                       GLKMathDegreesToRadians(-30.0f),
                                       0.0f,
                                       1.0f,
                                       0.0f);
    modelviewMatrix = GLKMatrix4Translate(
                                          modelviewMatrix,
                                          -0.25f,
                                          0.0f,
                                          -0.20f);
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;
    
    [(AGLKContext *)view.context enable:GL_BLEND];
    [(AGLKContext *)view.context setBlendSourceFunction:GL_SRC_ALPHA destinationFunction:GL_ONE_MINUS_SRC_ALPHA];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(
                                                                     -0.5 * aspectRatio,
                                                                     0.5 * aspectRatio,
                                                                     -0.5f,
                                                                     0.5f,
                                                                     -0.5f,
                                                                     5.0f);
    
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    // Prepare vertex buffers for drawing
    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                                   numberOfCoordinates:3
                                          attribOffset:0
                                          shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                                 numberOfCoordinates:3
                                        attribOffset:0
                                        shouldEnable:YES];
    
    // Save the current Modelview matrix
    GLKMatrix4 savedModelviewMatrix = self.baseEffect.transform.modelviewMatrix;
    
    // Combine all of the user chosen transforms in order
    GLKMatrix4 newModelviewMatrix = GLKMatrix4Multiply(savedModelviewMatrix, SceneMatrixForTransform(self.transform1Type, self.transform1Axis, self.transform1Value));
    newModelviewMatrix = GLKMatrix4Multiply(newModelviewMatrix, SceneMatrixForTransform(self.transform2Type, self.transform2Axis, self.transform2Value));
    newModelviewMatrix = GLKMatrix4Multiply(newModelviewMatrix, SceneMatrixForTransform(self.transform3Type, self.transform3Axis, self.transform3Value));
    
    // Set the Modelview matrix for drawing
    self.baseEffect.transform.modelviewMatrix = newModelviewMatrix;
    
    // Make the light white
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f,
                                                         1.0f,
                                                         1.0f,
                                                         1.0f);
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using vertices in the prepared vertex buffers
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:lowPolyAxesAndModels2NumVerts];

    // Restore the saved Modelview matrix
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
    
    // Change the light color
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f,
                                                         1.0f,
                                                         0.0f,
                                                         0.3f);
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using vertices in the prepared vertex buffers
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:lowPolyAxesAndModels2NumVerts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)resetIdentity:(id)sender {
    [self.transform1ValueSlider setValue:0.0];
    [self.transform2ValueSlider setValue:0.0];
    [self.transform3ValueSlider setValue:0.0];
    self.transform1Value = 0.0f;
    self.transform2Value = 0.0f;
    self.transform3Value = 0.0f;
}

- (IBAction)takeTransform1TypeFrom:(UISegmentedControl *)sender {
    self.transform1Type = (SceneTransformtionSelector)[sender selectedSegmentIndex];
}

- (IBAction)takeTransform2TypeFrom:(UISegmentedControl *)sender {
    self.transform2Type = (SceneTransformtionSelector)[sender selectedSegmentIndex];
}

- (IBAction)takeTransform3TypeFrom:(UISegmentedControl *)sender {
    self.transform3Type = (SceneTransformtionSelector)[sender selectedSegmentIndex];
}

- (IBAction)takeTransform1AxisFrom:(UISegmentedControl *)sender {
    self.transform1Axis = (SceneTransformationAxisSelector)[sender selectedSegmentIndex];
}

- (IBAction)takeTransform2AxisFrom:(UISegmentedControl *)sender {
    self.transform2Axis = (SceneTransformationAxisSelector)[sender selectedSegmentIndex];
}

- (IBAction)takeTransform3AxisFrom:(UISegmentedControl *)sender {
    self.transform3Axis = (SceneTransformationAxisSelector)[sender selectedSegmentIndex];//
}

- (IBAction)takeTransform1ValueFrom:(UISlider *)sender {
    self.transform1Value = [sender value];
}

- (IBAction)takeTransform2ValueFrom:(UISlider *)sender {
    self.transform2Value = [sender value];
}

- (IBAction)takeTransform3ValueFrom:(UISlider *)sender {
    self.transform3Value = [sender value];
}


@end

// Transform the current coordinate system according to the users selections stored in global variables, transform1Type, transformAxis, and transfrom1Value.
static GLKMatrix4 SceneMatrixForTransform(SceneTransformtionSelector type, SceneTransformationAxisSelector axis, float value)
{
    GLKMatrix4 result = GLKMatrix4Identity;
    switch (type) {
        case SceneRotate:
        {
            switch (axis) {
                case SceneXAxis:
                {
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0f * value),
                                                    1.0f,
                                                    0.0f,
                                                    0.0f);
                }
                    break;
                case SceneYAxis:
                {
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0f * value),
                                                    0.0f,
                                                    1.0f,
                                                    0.0f);
                }
                    break;
                case SceneZAxis:
                default:
                {
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0f * value),
                                                    0.0f,
                                                    0.0f,
                                                    1.0f);
                }
                    break;
            }
        }
            break;
        case SceneScale:
        {
            switch (axis) {
                case SceneXAxis:
                {
                    result = GLKMatrix4MakeScale(1.0f + value,
                                                 1.0f,
                                                 1.0f);
                }
                    break;
                case SceneYAxis:
                {
                    result = GLKMatrix4MakeScale(1.0f,
                                                 1.0f + value,
                                                 1.0f);
                }
                    break;
                case SceneZAxis:
                default:
                {
                    result = GLKMatrix4MakeScale(1.0f,
                                                 1.0f,
                                                 1.0f + value);
                }
                    break;
            }
        }
            break;
        default:
        {
            switch (axis) {
                case SceneXAxis:
                {
                    result = GLKMatrix4MakeTranslation(0.3f * value,
                                                       0.0f,
                                                       0.0f);
                }
                    break;
                case SceneYAxis:
                {
                    result = GLKMatrix4MakeTranslation(0.0f,
                                                       0.3f * value,
                                                       0.0f);
                }
                    break;
                case SceneZAxis:
                default:
                {
                    result = GLKMatrix4MakeTranslation(0.0f,
                                                       0.0f,
                                                       0.3f * value);
                }
                    break;
            }
        }
            break;
    }
    return result;
}



