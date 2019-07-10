//
//  AGLKVertexAttribArrayBuffer.m
//  GLTextureLearning
//
//  Created by Gguomingyue on 2017/6/27.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizeiptr stride;
//@property (nonatomic, assign) GLuint name;

@end

@implementation AGLKVertexAttribArrayBuffer

@synthesize name;
@synthesize bufferSizeBytes;
@synthesize stride;

// this method creats a vertex attribute array buffer in the current OpenGL ES context for the thread opon which this method is called;
-(id)initWithAttribStride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < aStride);
    NSAssert(0 < count && NULL != dataPtr || (0 == count && NULL == dataPtr), @"data must not be NULL or count > 0");
    if (nil != (self = [super init])) {
        stride = aStride;
        bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, self.name);
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage);
        
        NSAssert(0 != name, @"Failed to generate name");
    }
    return self;
}

// this method loads the data stored by the receiver.
-(void)reinitWithAttribStride:(GLsizeiptr)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr
{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != name, @"Invalid name");
    
    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}

// A vertex attribute array buffer must be prepared when your application wants to use the buffer to render any geometry.
// When your application prepare an buffer, some OpenGLES state is altered to allow bind the buffer and configure points.
-(void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != name, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
    
#ifdef DEBUG
    {
        GLenum error = glGetError();
        if (GL_NO_ERROR != error) {
            NSLog(@"GL Error:0x%x",error);
        }
    }
#endif
}

//Submits the drawing command identified by mode and instructs
//OpenGL ES to use count vertices from the buffer staring from the vertex at index first. Vertex indices start at 0.
-(void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride), @"Attempt to draw more vertex data than available");
    glDrawArrays(mode, first, count);
}

// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from previously prepared
// buffers starting from the vertex at index in the prepared buffers
+(void)drawPreparedArraysWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);
}

// This method deletes the receiver's buffer from the current
// Context when the receiver is deallocated
-(void)dealloc
{
    if (0 != name) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}




@end

