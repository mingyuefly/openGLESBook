//
//  ViewController.h
//  GLTextureLearning
//
//  Created by Gguomingyue on 2017/6/27.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//


#import <GLKit/GLKit.h>
//#import "AGLKVertexAttribArrayBuffer.h"

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController
{

}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

