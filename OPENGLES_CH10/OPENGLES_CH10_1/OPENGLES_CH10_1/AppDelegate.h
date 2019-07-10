//
//  AppDelegate.h
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, ViewDataSourceProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) UtilityModelManager *modelManager;
@property (nonatomic, strong, readonly) TETerrain *terrain;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;

@end

