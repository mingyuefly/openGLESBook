//
//  SceneRinkModel.m
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "SceneRinkModel.h"
#import "SceneMesh.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "bumperRink.h"

@implementation SceneRinkModel

// Initialize the receiver's properties with data from the bumperRink.h file.
-(instancetype)init
{
    SceneMesh *rinkMesh = [[SceneMesh alloc] initWithPositionCoords:bumperRinkVerts normalCoords:bumperRinkNormals texCoords0:NULL numberOfPositions:bumperRinkNumVerts indices:NULL numberOfIndices:0];
    self = [super initWithName:@"bumberRink" mesh:rinkMesh numberOfVertices:bumperRinkNumVerts];
    if (self) {
        [self updateAlignedBoundingBoxForVertices:bumperRinkVerts count:bumperRinkNumVerts];
    }
    return self;
}

@end
