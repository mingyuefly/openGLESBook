//
//  UtilityEffect.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface UtilityEffect : NSObject<GLKNamedEffect>
// This type identifies the vertex attributes used to render models, terrain, and billboard particles. Not all effects use all attributes.
typedef enum
{
    UtilityVertexAttribPosition = GLKVertexAttribPosition,
    UtilityVertexAttribNormal = GLKVertexAttribNormal,
    UtilityVertexAttribColor = GLKVertexAttribColor,
    UtilityVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    UtilityVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
    UtilityVertexAttribOpacity,
    UtilityVertexAttribJointMatrixIndices,
    UtilityVertexAttribJointNormalizedWeights,
    UtilityVertexNumberOfAttributes
}UtilityVertexAttribute;

@property (nonatomic, assign, readonly) GLuint program;

-(void)prepareOpenGL;
-(void)updateUniformValues;

// Required overrides
-(void)bindAttribLocations;
-(void)configureUniformLocations;
-(BOOL)loadShadersWithName:(NSString *)aShaderName;

@end
