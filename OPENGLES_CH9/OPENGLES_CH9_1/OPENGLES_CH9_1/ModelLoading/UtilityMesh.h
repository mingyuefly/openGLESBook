//
//  UtilityMesh.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

// Type used to store mesh vertex attributes
typedef struct{
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector2 texCoords0;
    GLKVector2 texCoords1;
}UtilityMeshVertex;

@interface UtilityMesh : NSObject
{
    GLuint indexBufferID_;
    GLuint vertexBufferID_;
    GLuint vertexExtraBufferID_;
    GLuint vertexArrayID_;
}

@property (nonatomic, strong, readonly) NSData *vertexData;
@property (nonatomic, strong, readonly) NSData *indexData;
@property (nonatomic, strong, readonly) NSMutableData *extraVertexData;
@property (nonatomic, assign, readonly) NSUInteger numberOfIndices;
@property (nonatomic, strong, readonly) NSArray *commands;
@property (nonatomic, strong, readonly) NSDictionary *plistRepresentation;
@property (nonatomic, copy, readonly) NSString *axisAlignedBoundingBoxString;
@property (nonatomic, assign, readwrite) BOOL shouldUseVAOExtension;

-(instancetype)initWithPlistRepresentation:(NSDictionary *)aDictionary;
-(UtilityMeshVertex)vertexAtIndex:(NSUInteger)anIndex;
-(GLushort)indexAtIndex:(NSUInteger)anIndex;
-(NSString *)axisAlignedBoundingBoxStringForCommandsInRange:(NSRange)aRange;

@end

// Constants used to access properties from a drawing command dictionary
extern NSString *const UtilityMeshCommandNumberOfIndices;
extern NSString *const UtilityMeshCommandFirstIndex;


