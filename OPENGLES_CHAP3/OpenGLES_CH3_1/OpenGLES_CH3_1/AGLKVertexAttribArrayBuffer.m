//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizeiptr stride;

@end

@implementation AGLKVertexAttribArrayBuffer

-(instancetype)initWithAttribStride:(GLsizeiptr)aStride
                   numberOfVertices:(GLsizei)count
                              bytes:(const GLvoid *)dataPtr
                              usage:(GLenum)usage
{
    NSParameterAssert(0 < aStride);
    NSAssert((0 < count && NULL != dataPtr) ||
             (0 == count && NULL == dataPtr),
             @"data must not be NULL or count > 0");
    if (nil != (self = [super init])) {
        self.stride = aStride;
        self.bufferSizeBytes = aStride * count;
        
        glGenBuffers(1, &_name);//step1
        glBindBuffer(GL_ARRAY_BUFFER, self.name);//step2
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, usage);//step3
        NSAssert(0 != _name, @"Failed to generate name");
    }
    return self;
}

-(void)reinitWithAttribStride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr
{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != _name, @"Invalid name");
    
    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}

-(void)prepareToDrawWithAttrib:(GLuint)index
           numberOfCoordinates:(GLint)count
                  attribOffset:(GLsizeiptr)offset
                  shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _name, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);//step2
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)self.stride, NULL + offset);
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

+(void)drawPreparedArraysWithMode:(GLenum)mode
                 startVertexIndex:(GLint)first
                 numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);
}

-(void)drawArrayWithMode:(GLenum)mode
        startVertexIndex:(GLint)first
        numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);
}

-(void)dealloc
{
    if (0 != self.name) {
        glDeleteBuffers(1, &_name);
        _name = 0;
    }
}


@end
