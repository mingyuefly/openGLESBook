//
//  UtilityModelManager.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/10.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@class UtilityModel;
@class UtilityMesh;

@interface UtilityModelManager : NSObject

@property (nonatomic, strong, readonly) GLKTextureInfo *textureInfo;
@property (nonatomic, strong, readonly) UtilityMesh *consolidatedMesh;

-(instancetype)init;
-(instancetype)initWithModelPath:(NSString *)aPath;

-(BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;
-(UtilityModel *)modelNamed:(NSString *)aName;

-(void)prepareToDraw;
-(void)prepareToPick;

@end

// Constants used to access model properties from a plist dictionary.
extern NSString *const UtilityModelManagerTextureImageInfo;
extern NSString *const UtilityModelManagerMesh;
extern NSString *const UtilityModelManagerModels;





