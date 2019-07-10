//
//  UtilityModelManager.m
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/10.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "UtilityModelManager.h"
#import "UtilityMesh+viewAdditions.h"
#import "UtilityModel+viewAdditions.h"
#import "UtilityTextureInfo+viewAdditions.h"

@interface UtilityModelManager ()

@property (nonatomic, strong, readwrite) GLKTextureInfo *textureInfo;
@property (nonatomic, strong, readwrite) UtilityMesh *consolidatedMesh;
@property (nonatomic, strong, readwrite) NSDictionary *modelsDictionary;

-(NSDictionary *)modelsFromPlistRepresentation:(NSDictionary *)plist mesh:(UtilityMesh *)aMesh;
-(BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;

@end

@implementation UtilityModelManager

@synthesize textureInfo = textureInfo_;
@synthesize consolidatedMesh = consolidatedMesh_;
@synthesize modelsDictionary = modelsDictionary_;

// Designated initializer
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//
-(id)initWithModelPath:(NSString *)aPath
{
    self = [self init];
    if (self) {
        NSError *modelLoadingError = nil;
        
        NSData *data = [NSData dataWithContentsOfFile:aPath options:0 error:&modelLoadingError];
        if (data) {
            [self readFromData:data ofType:[aPath pathExtension] error:&modelLoadingError];
        }
    }
    return self;
}

// This method returns a dictionary of UtilityModel instances keyed by name and intialized from plist.
-(NSDictionary *)modelsFromPlistRepresentation:(NSDictionary *)plist mesh:(UtilityMesh *)aMesh
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSDictionary *modelDictionary in plist.allValues) {
        UtilityModel *newModel = [[UtilityModel alloc] initWithPlistRepresentation:modelDictionary mesh:aMesh];
        [result setObject:newModel forKey:newModel.name];
    }
    return result;
}

// This method initializes the texture, mesh, and models loaded from a plist archived in data.
-(BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSDictionary *documentDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.textureInfo = [GLKTextureInfo textureInfoFromUtilityPlistRepresentation:[documentDictionary objectForKey:UtilityModelManagerTextureImageInfo]];
    self.consolidatedMesh = [[UtilityMesh alloc] initWithPlistRepresentation:[documentDictionary objectForKey:UtilityModelManagerMesh]];
    self.modelsDictionary = [self modelsFromPlistRepresentation:[documentDictionary objectForKey:UtilityModelManagerModels] mesh:self.consolidatedMesh];
    return YES;
}

// Returns the model with aName or nil if no such model is found.
-(UtilityModel *)modelNamed:(NSString *)aName
{
    return [self.modelsDictionary objectForKey:aName];
}

//
-(void)prepareToDraw
{
    [self.consolidatedMesh prepareToDraw];
}

//
-(void)prepareToPick
{
    [self.consolidatedMesh prepareToPick];
}

@end

// Constants used to access model properties from a plist dictionary.
NSString *const UtilityModelManagerTextureImageInfo = @"textureImageInfo";
NSString *const UtilityModelManagerMesh = @"mesh";
NSString *const UtilityModelManagerModels = @"models";











