//
//  TETerrain+viewAdditions.m
//  OPENGLES_CH10_1
//
//  Created by Gguomingyue on 2017/10/24.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "TETerrain+viewAdditions.h"
#import "TEModelPlacement.h"
#import "TETerrainTile.h"
#import "UtilityTerrainEffect.h"
#import "UtilityPickTerrainEffect.h"
#import "UtilityModelEffect.h"
#import "UtilityModelManager.h"
#import "UtilityModel+viewAdditions.h"
#import "UtilityCamera.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@implementation TETerrain (viewAdditions)

// This method returns an array of TETerrainTile instances that collectively cover the entire terrain. Each tile is a small rectangular cover the entire terrain. Each tile is a small rectangular section of terrain suitable for efficient rendering by OpenGL ES.
-(NSArray *)tiles
{
    NSMutableArray *tilesArray = [@[] mutableCopy];
    const NSInteger constLength = self.length;
    const NSInteger constWidth = self.width;
    
    for (NSInteger j = 0; j < constLength; j += (TETerrainTileDefaultLength - 1)) {
        for (NSInteger i = 0; i < constWidth; i += (TETerrainTileDefaultWidth - 1)) {
            TETerrainTile *tile = [[TETerrainTile alloc] initWithTerrain:self tileOriginX:i tileOriginY:j titleWidth:MIN(constWidth - i, TETerrainTileDefaultWidth) tileLength:MIN(constLength - j, TETerrainTileDefaultLength)];
            [tilesArray addObject:tile];
            
            // Associate model placements within the tile
            [tile manageContainedModelPlacements:self.modelPlacements];
        }
    }
    
    return nil;
}

#pragma mark - Render Support
// This method configures OpenGL ES state by binding buffers, and if necessary by passing vertex attribute data to the GPU.
-(void)prepareTerrainAttributes
{
    // Configure attributes
    if (0 == self.glVertexAttributeBufferID) {
        GLuint glName;
        glGenBuffers(1, &glName);
        glBindBuffer(GL_ARRAY_BUFFER, glName);
        glBufferData(GL_ARRAY_BUFFER,
                     [self.positionAttributesData length],
                     [self.positionAttributesData bytes],
                     GL_STATIC_DRAW);
        self.glVertexAttributeBufferID = glName;
    } else {
        glBindBuffer(GL_ARRAY_BUFFER, self.glVertexAttributeBufferID);
    }
    glEnableVertexAttribArray(TETerrainPositionAttrib);
}

// Return the distance squared between position1 and position2
GLfloat distanceSquared(GLKVector3 position1, GLKVector3 position2)
{
    GLKVector3 delta = GLKVector3Subtract(position2,
                                          position1);
    return GLKVector3DotProduct(delta, delta);
}

// This method submits vertex data to OpenGL for each tile in tiles. The pointer to the start of vertex data for each tile is set prior to rendering so that the vertex data for each tile within accessible range of a single glDrawElements() call per tile. Tiles are drawn via TETerrainTile's -draw method.
-(void)drawTiles:(NSArray *)tiles
{
    for (TETerrainTile * tile in tiles) {
        // Set the pointer to the first vertex position in the tile
        glVertexAttribPointer(TETerrainPositionAttrib, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), ((GLKVector3 *)NULL) + (tile.originY * self.width) + tile.originX);
        [tile draw];
    }
}

// This method submits vertex data to OpenGL for each tile in tiles. The pointer to the start of vertex data for each tile is set prior to rendering so that the vertex data for each tile is within accessible range of a single glDrawElements() call per tile. Tiles are drawn via TETerrainTile's -drawSimplified method.
-(void)drawSimpliliedTiles:(NSArray *)tiles
{
    for (TETerrainTile * tile in tiles) {
        // Set the pointer to the first vertex position in the tile
        glVertexAttribPointer(TETerrainPositionAttrib,
                              3,
                              GL_FLOAT,
                              GL_FALSE,
                              sizeof(GLKVector3),
                              ((GLKVector3 *)NULL) + (tile.originY * self.width) + tile.originX);
        [tile drawSimplified];
    }
}

// This method first draws all methods that need diffuse lighting and are contained within tiles. Then this method draws all models that don't need diffuse lighting and are contained within tiles. Using two separate batches minizes the number of OpenGL state change needed for lighting.
-(void)drawModelsWithinTiles:(NSArray *)tiles
                  withCamera:(UtilityCamera *)aCamera
                 modelEffect:(UtilityModelEffect *)aModelEffect
                modelManager:(UtilityModelManager *)modelManager
{
    const GLKMatrix4 modelviewMatrix = aModelEffect.modelviewMatrix;
    const GLfloat metersPerUnit = self.metersPerUnit;
    
    for (TETerrainTile *tile in tiles) {
        NSSet *modelPlacements = tile.containedModelPlacements;
        
        // Draw all models that require lighting
        for (TEModelPlacement * currentPlacement in modelPlacements) {
            UtilityModel *currentModel = [modelManager modelNamed:currentPlacement.modelName];
            if ([currentModel doesRequireLighting]) {
                GLKVector3 position = {
                    currentPlacement.positionX * metersPerUnit,
                    currentPlacement.positionY,
                    currentPlacement.positionZ * metersPerUnit
                };
                
                GLKMatrix4 newModelviewMatrix = GLKMatrix4Translate(modelviewMatrix,
                                                                    position.x,
                                                                    position.y,
                                                                    position.z);
                newModelviewMatrix =
                GLKMatrix4Rotate(newModelviewMatrix,
                                 GLKMathDegreesToRadians(currentPlacement.angle),
                                 0.0f,
                                 1.0f,
                                 0.0f);
                aModelEffect.modelviewMatrix = newModelviewMatrix;
                
                [aModelEffect prepareModelview];
                [currentModel draw];
            }
        }
    }
    
    GLKVector4 saveGlobalAmbientLightColor = aModelEffect.globalAmbientLightColor;
    GLKVector4 saveDiffuseLightColor = aModelEffect.diffuseLightColor;
    
    // Set light values to disable diffuse lighting
    aModelEffect.globalAmbientLightColor = GLKVector4Make(1.0f,
                                                          1.0f,
                                                          1.0f,
                                                          1.0f);
    aModelEffect.diffuseLightColor = GLKVector4Make(0.0f,
                                                    0.0f,
                                                    0.0f,
                                                    1.0f);
    [aModelEffect prepareLightColors];
    
    for (TETerrainTile *tile in tiles) {
        NSSet *modelPlacements = tile.containedModelPlacements;
        
        // Draw all models that don't require lighting
        for (TEModelPlacement *currentPlacement in modelPlacements) {
            UtilityModel *currentModel = [modelManager modelNamed:currentPlacement.modelName];
            if (![currentModel doesRequireLighting]) {
                GLKVector3 position = {
                    currentPlacement.positionX * metersPerUnit,
                    currentPlacement.positionY,
                    currentPlacement.positionZ * metersPerUnit
                };
                
                GLKMatrix4 newModelviewMatrix =
                GLKMatrix4Translate(modelviewMatrix,
                                    position.x,
                                    position.y,
                                    position.z);
                newModelviewMatrix =
                GLKMatrix4Rotate(newModelviewMatrix,
                                 GLKMathDegreesToRadians(currentPlacement.angle),
                                 0.0f,
                                 1.0f,
                                 0.0f);
                aModelEffect.modelviewMatrix = newModelviewMatrix;
                
                // Update the modelview matrix but there is no need update the normal matrix because opengl lighting is not being used.
                [aModelEffect prepareModelviewWithoutNormal];
                [currentModel draw];
            }
        }
    }
    
    // Restore saved light values
    aModelEffect.globalAmbientLightColor = saveGlobalAmbientLightColor;
    aModelEffect.diffuseLightColor = saveDiffuseLightColor;
}

// This method prepares aTerrainEffect for rendering and draws the terrain within the tiles provided. Tiles in fullDetailTiles are drawn with full detail. Tiles in simplifiedTiles are drawn with full detail. Tiles in simplifiedTiles are drawn simplified.
-(void)drawTerrainWithinTiles:(NSArray *)tiles
                   withCamera:(UtilityCamera *)aCamera
                terrainEffect:(UtilityTerrainEffect *)aTerrainEffect
{
    glBindVertexArray(0);
    
    // Draw the terrain for tiles that weren't called
    aTerrainEffect.projectionMatrix = aCamera.projectionMatrix;
    aTerrainEffect.modelviewMatrix = aCamera.modelviewMatrix;
    
    [self prepareTerrainAttributes];
    [aTerrainEffect prepareToDraw];
    
    [self drawTiles:tiles];
}

#pragma mark - Picking Support
// This method prepares aPickEffect for rendering, clears the frame buffer and draws the terrain within tiles.
-(void)prepareToPickTerrain:(NSArray *)tiles
                 withCamera:(UtilityCamera *)aCamera
                 PickEffect:(UtilityPickTerrainEffect *)aPickEffect
{
    glBindVertexArray(0);
    
    // Draw the terrain for tiles that weren't culled
    aPickEffect.modelIndex = 0;
    aPickEffect.projectionMatrix = aCamera.projectionMatrix;
    aPickEffect.modelviewMatrix = aCamera.modelviewMatrix;
    
    [self prepareTerrainAttributes];
    [aPickEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self drawTiles:tiles];
}

@end