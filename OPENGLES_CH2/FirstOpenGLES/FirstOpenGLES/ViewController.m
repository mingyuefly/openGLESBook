//
//  ViewController.m
//  FirstOpenGLES
//
//  Created by Gguomingyue on 2017/6/12.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *mContext;
@property (nonatomic, strong) GLKBaseEffect *mEffect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建openGLES上下文
    [self setupConfig];
    
    //顶点数组和索引数组
    [self uploadVertexArray];
    
    //纹理贴图
    [self uploadTexture];
}

-(void)setupConfig
{
    //新建openGLES上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];//API选择2.0
    GLKView *view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;//颜色缓冲格式
    [EAGLContext setCurrentContext:self.mContext];
}

-(void)uploadVertexArray
{
    //顶点数据，前三个是顶点数据，后两个是纹理数据
    GLfloat squareVertexData[] =
    {
        0.5, -0.5,  0.0f,   1.0f, 0.0f, //右下
        0.5,  0.5, -0.0f,   1.0f, 1.0f, //右上
       -0.5,  0.5,  0.0f,   0.0f, 1.0f, //左上
        
        0.5, -0.5,  0.0f,   1.0f, 0.0f, //右下
       -0.5,  0.5,  0.0f,   0.0f, 1.0f, //左上
       -0.5, -0.5,  0.0f,   0.0f, 0.0f, //左下
    };
    
    /*第二种方法
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f, 1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f, 1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f, 0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f, 0.0f, 0.0f, //左下
    };
    GLbyte indices[] =
    {
        0,1,2,
        2,3,0
    };
     */
    
    //顶点数据缓存
    //step1
    GLuint buffer;
    glGenBuffers(1, &buffer);//一个缓存标识符生成，并保存在buffer实例变量中
    //step2
    glBindBuffer(GL_ARRAY_BUFFER, buffer);//绑定用于指定标识符的缓存到当前缓存,GL_ARRAY_BUFFER用于指定一个顶点属性数组
    //step3
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);//复制应用的顶点数据到当前上下文所绑定的顶点缓存中
    //第一个参数GL_ARRAY_BUFFER指定要更新当前上下文中所绑定的是哪一个缓存
    //第二个参数sizeof(squareVertexData)指定要复制进这个缓存的字节的数量
    //第三个参数squareVertexData是要复制的字节的地址
    //第四个参数提示了缓存在未来的运算中将会被怎样利用,GL_STATIC_DRAW提示会告诉上下文，缓存中的内容适合复制到GPU控制的内存,因为很少对其进行修改。这个信息可以帮助OpenGL ES优化内存使用。使用GL_DYNAMIC_DRAW作为提示上下文，缓存内数据会频繁改变，同时提示OpenGL ES以不同的方式来处理缓存的存储。
    
    //step4
    glEnableVertexAttribArray(GLKVertexAttribPosition);//启动顶点数据缓存渲染操作
    //step5
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);//设置指针
    //此函数会告诉OpenGL ES顶点数据在哪里，以及解释怎么解释为每个顶点保存数据
    //GLKVertexAttribPosition第一个参数指示当前绑定的缓存包含每个顶点的位置信息
    //3第二个参数表示每个位置有3个部分
    //GL_FLOAT第三个参数告诉OpenGL ES每个部分都保存为一个浮点类型的值
    //sizeof(GLfloat) * 5第四个参数告诉OpenGL ES小数点固定数据是否可以被改变
    //(GLfloat *)NULL + 0第五个参数为步长，规定了每个顶点的保存需要多少个字节,NULL告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    /*第二种方法
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    GLuint texturebuffer;
    glGenBuffers(1, &texturebuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, texturebuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
     */
}

-(void)uploadTexture
{
    //纹理贴图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@".jpg"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
}

//渲染场景代码
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);//清除颜色,并重新设置参数的颜色
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);//清除之前缓存
    
    //启动着色器
    [self.mEffect prepareToDraw];
    //step6
    glDrawArrays(GL_TRIANGLES, 0, 6);//执行绘图
    //GL_TRIANGLES第一个参数告诉GPU怎么处理在绑定的顶点缓存内的顶点数据,这里指示OpenGL ES去渲染三角形
    //0第二个参数指定缓存内的需要渲染的第一个顶点的位置
    //6第三个参数指定缓存内需要渲染的顶点数量
    
    /*第二种方法
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
