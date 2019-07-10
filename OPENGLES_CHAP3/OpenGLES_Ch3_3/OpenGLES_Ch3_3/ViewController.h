//
//  ViewController.h
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, assign) BOOL shouldUseLinearFilter;
@property (nonatomic, assign) BOOL shouldAnimate;
@property (nonatomic, assign) BOOL shouldRepeatTexture;
@property (nonatomic, assign) GLfloat sCoordinateOffset;

- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender;
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender;
- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender;
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender;


@end

