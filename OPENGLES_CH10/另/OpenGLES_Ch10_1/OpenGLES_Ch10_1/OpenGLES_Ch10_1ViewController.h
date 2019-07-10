//
//  ViewController.h
//  OpenGLES_Ch10_1
//
//  Created by Gguomingyue on 2017/10/27.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class UtilityCamera;
@class UtilityTerrainEffect;
@class UtilityModelManager;
@class TETerrain;


@protocol OpenGLES_Ch10_1ViewDataSourceProtocol <NSObject>

- (TETerrain *)terrain;
- (UtilityModelManager *)modelManager;
- (NSManagedObjectContext *)managedObjectContext;

@end


@interface OpenGLES_Ch10_1ViewController : GLKViewController
<UIGestureRecognizerDelegate>

@property (strong, nonatomic, readonly)
UtilityTerrainEffect *terrainEffect;
@property (strong, nonatomic, readonly)
UtilityCamera *camera;

@property (strong, nonatomic, readwrite)
IBOutlet id <OpenGLES_Ch10_1ViewDataSourceProtocol> dataSource;
@property (strong, nonatomic) IBOutlet UILabel *fpsField;

@end
