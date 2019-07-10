//
//  ViewController.h
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SceneCar.h"

@interface ViewController : GLKViewController<SceneCarControllerProtocol>

@property (nonatomic, strong, readonly) NSArray *cars;
@property (nonatomic, assign, readonly) SceneAxisAllignedBoundingBox rinkBoundingBox;

@end

