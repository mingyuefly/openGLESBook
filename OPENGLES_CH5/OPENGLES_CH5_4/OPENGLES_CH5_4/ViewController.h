//
//  ViewController.h
//  OPENGLES_CH5_4
//
//  Created by Gguomingyue on 2017/9/20.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

// Constants identify user selected transformations
typedef enum{
    SceneTranslate   = 0,
    SceneRotate      = 1,
    SceneScale       = 2
}SceneTransformtionSelector;

// Constants identity user selected axis for transformation
typedef enum{
    SceneXAxis    = 0,
    SceneYAxis    = 1,
    SceneZAxis    = 2
}SceneTransformationAxisSelector;

@interface ViewController : GLKViewController

@property (nonatomic, assign) SceneTransformtionSelector       transform1Type;
@property (nonatomic, assign) SceneTransformationAxisSelector  transform1Axis;
@property (nonatomic, assign) float                            transform1Value;
@property (nonatomic, assign) SceneTransformtionSelector       transform2Type;
@property (nonatomic, assign) SceneTransformationAxisSelector  transform2Axis;
@property (nonatomic, assign) float                            transform2Value;
@property (nonatomic, assign) SceneTransformtionSelector       transform3Type;
@property (nonatomic, assign) SceneTransformationAxisSelector  transform3Axis;
@property (nonatomic, assign) float                            transform3Value;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer * vertexNormalBuffer;
@property (weak, nonatomic) IBOutlet UISlider *transform1ValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *transform2ValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *transform3ValueSlider;

- (IBAction)resetIdentity:(id)sender;
- (IBAction)takeTransform1TypeFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform2TypeFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform3TypeFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform1AxisFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform2AxisFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform3AxisFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform1ValueFrom:(UISlider *)sender;
- (IBAction)takeTransform2ValueFrom:(UISlider *)sender;
- (IBAction)takeTransform3ValueFrom:(UISlider *)sender;


@end

