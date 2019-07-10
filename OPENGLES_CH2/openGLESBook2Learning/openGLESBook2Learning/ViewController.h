//
//  ViewController.h
//  openGLESBook2Learning
//
//  Created by Gguomingyue on 2017/6/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKViewController.h"
#import <GLKit/GLKit.h>

@interface ViewController : AGLKViewController
{
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

