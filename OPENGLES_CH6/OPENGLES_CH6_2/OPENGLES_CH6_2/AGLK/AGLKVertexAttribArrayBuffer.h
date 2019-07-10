//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKElementIndexArrayBuffer;

typedef enum {
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
}AGLKVertexAttrib;

@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, assign, readonly) GLuint name;
@property (nonatomic, assign, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign, readonly) GLsizeiptr stride;

+(void)drawPreparedArraysWithMode:(GLenum)mode
                 startVertexIndex:(GLint)first
                 numberOfVertices:(GLsizei)count;

- (id)initWithAttribStride:(GLsizeiptr)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizeiptr)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;


@end
