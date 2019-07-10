//
//  ViewController.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SceneCar.h"

@interface ViewController : GLKViewController<SceneCarControllerProtocol>

@property (nonatomic, strong, readonly) NSArray *cars;
@property (nonatomic, assign, readonly) AGLKAxisAllignedBoundingBox rinkBoundingBox;

@end

