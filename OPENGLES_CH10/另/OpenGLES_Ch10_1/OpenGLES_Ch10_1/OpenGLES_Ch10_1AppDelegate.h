//
//  AppDelegate.h
//  OpenGLES_Ch10_1
//
//  Created by Gguomingyue on 2017/10/27.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLES_Ch10_1ViewController.h"

@interface OpenGLES_Ch10_1AppDelegate : UIResponder<UIApplicationDelegate,OpenGLES_Ch10_1ViewDataSourceProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly)
UtilityModelManager *modelManager;
@property (strong, nonatomic, readonly)
TETerrain *terrain;
@property (readonly, strong, nonatomic)
NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic)
NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic)
NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
