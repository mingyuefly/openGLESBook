//
//  ViewController.h
//  OPENGLES_CH4_2
//
//  Created by Gguomingyue on 2017/9/15.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic, strong) GLKTextureInfo *blandTextureInfo;
@property (nonatomic, strong) GLKTextureInfo *interestingTextureInfo;
@property (nonatomic, assign) BOOL shouldUseDetailLighting;

- (IBAction)takeShouldUseDetailLightingFrom:(UISwitch *)sender;

@end

