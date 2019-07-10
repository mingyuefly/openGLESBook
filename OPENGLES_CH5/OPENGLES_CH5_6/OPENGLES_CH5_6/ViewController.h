//
//  ViewController.h
//  OPENGLES_CH5_6
//
//  Created by Gguomingyue on 2017/9/25.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;
@property (nonatomic, strong) GLKTextureInfo *earthTextureInfo;
@property (nonatomic, strong) GLKTextureInfo *moonTextureInfo;
@property (nonatomic) GLKMatrixStackRef modelviewMatrixStack;
@property (nonatomic) GLfloat earthRotationAngleDegrees;
@property (nonatomic) GLfloat moonRotaionAngleDegrees;

- (IBAction)takeShouldUsePerspectiveFrom:(UISwitch *)sender;

@end

