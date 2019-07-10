//
//  ViewController.h
//  OPENGLES_CH5_2
//
//  Created by Gguomingyue on 2017/9/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;

@end

