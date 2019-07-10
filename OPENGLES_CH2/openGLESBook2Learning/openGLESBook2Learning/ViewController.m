//
//  ViewController.m
//  openGLESBook2Learning
//
//  Created by Gguomingyue on 2017/6/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize baseEffect;

typedef struct{
    GLKVector3  positionCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AGLKView *view = (AGLKView *)self.view;
    NSAssert([view isKindOfClass:[AGLKView class]],
             @"View controller's view is not a AGLKView");
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   0.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    // Set the background color stored in the current context
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f); // background color
    
    // Generate, bind, and initialize contents of a buffer to be
    // stored in GPU memory
    glGenBuffers(1,                // STEP 1
                 &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 vertexBufferID);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 sizeof(vertices), // Number of bytes to copy
                 vertices,         // Address of bytes to copy
                 GL_STATIC_DRAW);  // Hint: cache in GPU memory
    
}

- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Enable use of positions from bound vertex buffer
    glEnableVertexAttribArray(      // STEP 4
                              GLKVertexAttribPosition);
    
    glVertexAttribPointer(          // STEP 5
                          GLKVertexAttribPosition,
                          3,                   // three components per vertex
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex), // no gaps in data
                          NULL);               // NULL tells GPU to start at
    // beginning of bound buffer
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES,      // STEP 6
                 0,  // Start with first vertex in currently bound buffer
                 3); // Use three vertices from currently bound buffer
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Delete buffers that aren't needed when view is unloaded
    if (0 != vertexBufferID)
    {
        glDeleteBuffers (1,          // STEP 7
                         &vertexBufferID);
        vertexBufferID = 0;
    }
    
    // Stop using the context created in -viewDidLoad
    ((AGLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
