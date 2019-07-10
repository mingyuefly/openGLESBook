//
//  ViewController.m
//  OpenGLESBookFirst
//
//  Created by Gguomingyue on 2017/6/15.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}},//lower left corner
    {{0.5f, -0.5f, 0.0}},//lower right corner
    //{{0.5f, 0.5f, 0.0}},
    {{-0.5f, 0.5f, 0.0}},//upper left corner
};

/*第二种
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}},//lower left corner
    {{0.5f, -0.5f, 0.0}},//lower right corner
    //{{0.5f, 0.5f, 0.0}},
    {{-0.5f, 0.5f, 0.0}},//upper left corner
    
    {{0.5f, -0.5f, 0.0}},//lower right corner
    {{0.5f, 0.5f, 0.0}},//upper right corner
    //{{0.5f, 0.5f, 0.0}},
    {{-0.5f, 0.5f, 0.0}},//upper left corner
};
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    GLuint vertexBufferID;
    //step1
    glGenBuffers(1, &vertexBufferID);
    //step2
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //step3
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    //step4
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //step5
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    //step6
    glDrawArrays(GL_TRIANGLES, 0, 3);
    /*第二种
     glDrawArrays(GL_TRIANGLES, 0, 6);
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
