//
//  UtilityMesh+skinning.h
//  OPENGLES_CH7_2
//
//  Created by Gguomingyue on 2017/10/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityMesh.h"

// Type used to store vertex skinning attributes
typedef struct
{
    GLKVector4 jointIndices; // encoded float for Shading Language
    GLKVector4 jointWeights; // weight factor for each joint index
}UtilityMeshJointInfluence;

@interface UtilityMesh (skinning)

-(void)setJointInfluence:(UtilityMeshJointInfluence)aJointInfluence atIndex:(GLsizei)vertexIndex;
-(void)prepareToDrawWithJointInfluence;

@end
