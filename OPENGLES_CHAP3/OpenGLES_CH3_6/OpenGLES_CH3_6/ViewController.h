//
//  ViewController.h
//  OpenGLES_CH3_6
//
//  Created by Gguomingyue on 2017/9/8.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) GLKMatrix4 modelViewProjectionMatrix;
@property (nonatomic, assign) GLKMatrix3 normalMatrix;
@property (nonatomic, assign) GLfloat rotation;
@property (nonatomic, assign) GLuint vertexArray;
//@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint texture0ID;
@property (nonatomic, assign) GLuint texture1ID;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

