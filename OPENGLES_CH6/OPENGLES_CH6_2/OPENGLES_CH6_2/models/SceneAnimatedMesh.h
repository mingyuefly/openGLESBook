//
//  SceneAnimatedMesh.h
//  OPENGLES_CH6_2
//
//  Created by Gguomingyue on 2017/9/29.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "SceneMesh.h"

@interface SceneAnimatedMesh : SceneMesh

-(void)drawEntireMesh;
-(void)updateMeshWithDefaultPositions;
-(void)updateMeshWithElapsedTime:(NSTimeInterval)anInterval;

@end
