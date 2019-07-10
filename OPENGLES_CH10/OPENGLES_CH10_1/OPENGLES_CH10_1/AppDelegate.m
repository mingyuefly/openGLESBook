//
//  AppDelegate.m
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/23.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "AppDelegate.h"
#import "TETerrain+viewAdditions.h"
#import "UtilityModelManager.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) TETerrain *terrain;

@end

@implementation AppDelegate

@synthesize modelManager;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Terrain" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSArray *terrainArray = nil;
    NSError *error = nil;
    
    @try
    {
        terrainArray = [[self managedObjectContext] executeFetchRequest:request error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    @finally
    {
    }
    
    if (terrainArray != nil) {
        NSUInteger count = [terrainArray count];
        if (1 == count) {
            // Use the existing instance
            self.terrain = [terrainArray lastObject];
        } else {
            // Too many existing instances or not enough
            // Deal with error.
        }
    } else {
        // Deal with error.
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setStatusBarHidden:YES
                      withAnimation:UIStatusBarAnimationFade];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@",
                  error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
// Returns the managed object context for the application. If the context doesn't already exist, it is created and bound to the persistent store coordinate for the application.
-(NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
-(NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OpenGLES_Ch10_1" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Return the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[NSBundle mainBundle]
                       URLForResource:@"trail" withExtension:@"binary"];
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                forKey:NSReadOnlyPersistentStoreOption];
    NSError *error = nil;
    __persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc]
     initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSBinaryStoreType 
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Model Manager
//
-(UtilityModelManager *)modelManager
{
    if (!modelManager && nil != self.terrain.modelsData) {
        modelManager = [[UtilityModelManager alloc] init];
        [modelManager readFromData:self.terrain.modelsData
                            ofType:nil
                             error:NULL];
    }
    return modelManager;
}



@end
