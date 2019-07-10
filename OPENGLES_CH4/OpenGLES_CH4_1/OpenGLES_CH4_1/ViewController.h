//
//  ViewController.h
//  OpenGLES_CH4_1
//
//  Created by Gguomingyue on 2017/9/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) GLKBaseEffect *extraEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *extraBuffer;

@property (nonatomic, assign) GLfloat centerVertexHeight;
@property (nonatomic, assign) BOOL shouldUseFaceNormals;
@property (nonatomic, assign) BOOL shouldDrawNormals;

- (IBAction)takeShouldUseFaceNormalsFrom:(UISwitch *)sender;
- (IBAction)takeShouldDrawNormalsFrom:(UISwitch *)sender;
- (IBAction)takeCenterVertexHeightFrom:(UISlider *)sender;

@end

