//
//  ViewController.m
//  OpenGLES_Ch3_3
//
//  Created by Gguomingyue on 2017/9/7.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value
{
    glBindTexture(self.target, self.name);
    glTexParameterf(self.target, parameterID, value);
}

@end

@interface ViewController ()

@end

@implementation ViewController

typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] =
{
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredFramesPerSecond = 60;//每秒刷新60次
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_DYNAMIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"grid.png"].CGImage;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - update
-(void)update
{
    [self updateTextureParameters];
    [self updateAnimatedVertexPositions];
    
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices];
}

-(void)updateTextureParameters
{
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:(self.shouldRepeatTexture?GL_REPEAT:GL_CLAMP_TO_EDGE)];
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER value:(self.shouldUseLinearFilter?GL_LINEAR:GL_NEAREST)];
}

-(void)updateAnimatedVertexPositions
{
    if (self.shouldAnimate) {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    {
        // Adjust the S texture coordinates to slide texture and reveal effect of texture repeat vs. clamp behavior
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].textureCoords.s = defaultVertices[i].textureCoords.s + self.sCoordinateOffset;
        }
    }
}

#pragma mark - actions
- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender
{
    self.sCoordinateOffset = sender.value;
}

- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender
{
    self.shouldRepeatTexture = sender.isOn;
}

- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender
{
    self.shouldAnimate = sender.isOn;
}

- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender
{
    self.shouldUseLinearFilter = sender.isOn;
}
@end
