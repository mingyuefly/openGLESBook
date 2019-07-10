//
//  ViewController.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "UtilityCamera.h"
#import "UtilityTerrainEffect.h"

@class UtilityCamera;
@class UtilityTerrainEffect;
@class UtilityModelManager;
@class TETerrain;

@protocol ViewDataSourceProtocol<NSObject>

-(TETerrain *)terrain;
-(UtilityModelManager *)modelManager;
-(NSManagedObjectContext *)managedObjectContext;

@end

@interface ViewController : GLKViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fpsField;
@property (nonatomic, strong) UtilityTerrainEffect *terrainEffect;
@property (nonatomic, strong) UtilityCamera *camara;
@property (nonatomic, weak) id<ViewDataSourceProtocol>dataSource;

@end

