//
//  ViewController.h
//  OPENGLES_CH6_4
//
//  Created by mingyue on 2017/10/2.
//  Copyright © 2017年 G. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKTextureTransformBaseEffect;
@class SceneAnimatedMesh;
@class SceneCanLightModel;

@interface ViewController : GLKViewController

@property (nonatomic, strong) AGLKTextureTransformBaseEffect *baseEffect;
@property (nonatomic, strong) SceneAnimatedMesh *animatedMesh;
@property (nonatomic, strong) SceneCanLightModel *canLightModel;
@property (nonatomic, assign) GLfloat spotLight0TiltAboutXAngleDeg;
@property (nonatomic, assign) GLfloat spotLight0TiltAboutZAngleDeg;
@property (nonatomic, assign) GLfloat spotLight1TiltAboutXAngleDeg;
@property (nonatomic, assign) GLfloat spotLight1TiltAboutZAngleDeg;

@end

