//
//  ViewController.h
//  OPENGLES_CH5_5
//
//  Created by Gguomingyue on 2017/9/21.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;
@class AGLKTextureTransformBaseEffect;

@interface ViewController : GLKViewController

@property (nonatomic, strong) AGLKTextureTransformBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, assign) float textureScaleFactor;
@property (nonatomic, assign) float textureAngle;
@property (nonatomic, assign) GLKMatrixStackRef textureMatrixStack;

// Methods called from user interface objects configured in Interface Builder
- (IBAction)takeTextureScaleFactorFrom:(UISlider *)sender;
- (IBAction)takeTextureAngleFrom:(UISlider *)sender;


@end

