//
//  AGLKSkyboxEffect.m
//  OPENGLES_CH8_2
//
//  Created by Gguomingyue on 2017/10/16.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AGLKSkyboxEffect.h"
#import <OpenGLES/ES2/glext.h>

// cube has 2 triangles x 6 sides + 2 for strip = 14
const static int AGLKSkyboxNumVertexIndices = 14;

// cube has 8 corners x 3 floats per vertex = 24
const static int AGLKSkyboxNumCoords = 24;

// GLSL program uniform indices;
enum
{
    AGLKMVPMatrix,
    AGLKSamplesCube,
    AGLKNumUniforms
};

@interface AGLKSkyboxEffect ()
{
    GLuint vertexBufferID;
    GLuint indexBufferID;
    GLuint program;
    GLuint vertexArrayID;
    GLint uniforms[AGLKNumUniforms];
}

-(BOOL)loadShaders;
-(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
-(BOOL)linkProgram:(GLint)prog;
-(BOOL)validateProgram:(GLuint)prog;

@end

@implementation AGLKSkyboxEffect

@synthesize textureCubeMap = _textureCubeMap;
@synthesize transform = _transform;

#pragma mark - construction functions

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.center = GLKVector3Make(0, 0, 0);
        self.xSize = 1.0f;
        self.ySize = 1.0f;
        self.zSize = 1.0f;
        
        // The 8 corners of a cube
        const float vertices[AGLKSkyboxNumCoords] = {
            -0.5, -0.5,  0.5,
             0.5, -0.5,  0.5,
            -0.5,  0.5,  0.5,
             0.5,  0.5,  0.5,
            -0.5, -0.5, -0.5,
             0.5, -0.5, -0.5,
            -0.5,  0.5, -0.5,
             0.5,  0.5, -0.5,
        };
        
        glGenBuffers(1, &vertexBufferID);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
        glBufferData(GL_ARRAY_BUFFER,
                     sizeof(vertices),
                     vertices,
                     GL_STATIC_DRAW);
        
        // Indices of triangle strip to draw cube
        // Order is critical to make "front" faces to be on inside of cube.
        const GLubyte indices[AGLKSkyboxNumVertexIndices] = {
            1, 2, 3, 7, 1, 5, 4, 7, 6, 2, 4, 0, 1, 2
        };
        glGenBuffers(1, &indexBufferID);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferID);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    }
    return self;
}

-(void)dealloc
{
    if (0 != vertexArrayID) {
        glDeleteVertexArraysOES(1, &vertexArrayID);
        vertexArrayID = 0;
    }
    if (0 != indexBufferID) {
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDeleteBuffers(1, &vertexBufferID);
    }
    if (0 != indexBufferID) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        glDeleteBuffers(1, &indexBufferID);
    }
    if (0 != program) {
        glUseProgram(0);
        glDeleteProgram(program);
    }
}

-(void)prepareToDraw
{
    if (0 == program) {
        [self loadShaders];
    }
    if (0 != program) {
        glUseProgram(program);
        
        // Translate skybox cube to specified center and scale to specified size
        GLKMatrix4 skyboxModelView = GLKMatrix4Translate(self.transform.modelviewMatrix, self.center.x, self.center.y, self.center.z);
        skyboxModelView = GLKMatrix4Scale(skyboxModelView, self.xSize, self.ySize, self.zSize);
        
        // Pre-calculate the combined mvpMatrix
        GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(self.transform.projectionMatrix, skyboxModelView);
        
        // Set the mvp matrix uniform varible
        glUniformMatrix4fv(uniforms[AGLKMVPMatrix], 1, 0, modelViewProjectionMatrix.m);
        
        // One texture sampler uniform variable
        
        if (0 == vertexArrayID) {
            // Set vertex attribute pointers
            glGenVertexArraysOES(1, &vertexArrayID);
            glBindVertexArrayOES(vertexArrayID);
            
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
            glVertexAttribPointer(GLKVertexAttribPosition,
                                  3,
                                  GL_FLOAT,
                                  GL_FALSE,
                                  0,
                                  NULL);
        } else {
            // The following function call restores all of the vertex attribute pointers previously prepared and associated with vertexArrayID
            glBindVertexArrayOES(vertexBufferID);
        }
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferID);
        
        // Bind the texture to be used
        if (self.textureCubeMap.enabled) {
            glBindTexture(GL_TEXTURE_CUBE_MAP, self.textureCubeMap.name);
        } else {
            glBindTexture(GL_TEXTURE_CUBE_MAP, 0);
        }
    }
}

//
-(void)draw
{
    glDrawElements(GL_TRIANGLE_STRIP,
                   AGLKSkyboxNumVertexIndices,
                   GL_UNSIGNED_BYTE,
                   NULL);
}

#pragma mark - OpenGL ES 2 shader compilation
-(BOOL)loadShaders
{
    GLuint vertexShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"AGLKSkyboxShader" ofType:@"vsh"];
    if (![self compileShader:&vertexShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"AGLKSkyboxShader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertexShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, GLKVertexAttribPosition, "a_position");
    
    // Link program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program:%d",program);
        if (vertexShader) {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        return NO;
    }
    
    // Get uniform location.
    uniforms[AGLKMVPMatrix] = glGetUniformLocation(program, "u_mvpMatrix");
    uniforms[AGLKSamplesCube] = glGetUniformLocation(program, "u_samplersCube");
    
    // Delete vertex and fragment shaders.
    if (vertexShader) {
        glDetachShader(program, vertexShader);
        glDeleteShader(vertexShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    return YES;
}

//
-(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const char *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s",log);
        free(log);
    }
#endif
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

//
-(BOOL)linkProgram:(GLint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s",log);
        free(log);
    }
#endif
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

//
-(BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s",log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - getters and setters
-(GLKEffectPropertyTexture *)textureCubeMap
{
    if (!_textureCubeMap) {
        _textureCubeMap = [[GLKEffectPropertyTexture alloc] init];
        _textureCubeMap.enabled = YES;
        _textureCubeMap.name = 0;
        _textureCubeMap.target = GLKTextureTargetCubeMap;
        _textureCubeMap.envMode = GLKTextureEnvModeReplace;
    }
    return _textureCubeMap;
}

-(GLKEffectPropertyTransform *)transform
{
    if (!_transform) {
        _transform = [[GLKEffectPropertyTransform alloc] init];
    }
    return _transform;
}










@end
