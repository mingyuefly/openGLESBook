//
//  SceneMesh.h
//  OPENGLES_CH6_1
//
//  Created by Gguomingyue on 2017/9/26.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef struct{
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector3 texCoords0;
}SceneMeshVertex;

@interface SceneMesh : NSObject

-(instancetype)initWithVertexAttributeData:(NSData *)vertexAttributes
                                 indexData:(NSData *)indices;

-(instancetype)initWithPositionCoords:(const GLfloat *)somePositions
                         normalCoords:(const GLfloat *)someNormals
                           texCoords0:(const GLfloat *)someTexCoords0
                    numberOfPositions:(size_t)countPositions
                              indices:(const GLushort *)someIndices
                      numberOfIndices:(size_t)countIndices;

-(void)prepareToDraw;

-(void)drawUnidexedWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

-(void)makeDynamicAndUpdateWithVertices:(const SceneMeshVertex *)someVerts numberOfVertices:(size_t)count;

@end
