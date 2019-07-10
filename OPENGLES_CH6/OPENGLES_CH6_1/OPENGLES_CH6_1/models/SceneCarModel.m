//
//  SceneCarModel.m
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "SceneCarModel.h"
#import "SceneMesh.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "bumperCar.h"

@implementation SceneCarModel

// Initialize the receiver's properties with data from the bumperCar.h file.
-(instancetype)init
{
    SceneMesh *carMesh = [[SceneMesh alloc] initWithPositionCoords:bumperCarVerts normalCoords:bumperCarNormals texCoords0:NULL numberOfPositions:bumperCarNumVerts indices:NULL numberOfIndices:0];
    self = [super initWithName:@"bumberCar" mesh:carMesh numberOfVertices:bumperCarNumVerts];
    if (self) {
        [self updateAlignedBoundingBoxForVertices:bumperCarVerts count:bumperCarNumVerts];
    }
    return self;
}

@end
