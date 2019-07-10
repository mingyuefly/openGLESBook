//
//  SceneCanLightModel.m
//  OPENGLES_CH6_3
//
//  Created by Gguomingyue on 2017/9/30.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "SceneCanLightModel.h"
#import "SceneMesh.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "canLight.h"

@implementation SceneCanLightModel

// Initialize the receiver's properties with data from the SceneCanLightModel.h file.
-(instancetype)init
{
    SceneMesh *canLightMesh = [[SceneMesh alloc] initWithPositionCoords:canLightVerts normalCoords:canLightNormals texCoords0:NULL numberOfPositions:canLightNumVerts indices:NULL numberOfIndices:0];
    self = [super initWithName:@"canLight" mesh:canLightMesh numberOfVertices:canLightNumVerts];
    if (self) {
        [self updateAlignedBoundingBoxForVertices:canLightVerts count:canLightNumVerts];
    }
    return self;
}

@end
