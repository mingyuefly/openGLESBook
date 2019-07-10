//
//  AGLKAxisAllignedBoundingBox.h
//  OPGLES_CH7_1
//
//  Created by Gguomingyue on 2017/10/9.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#ifndef AGLKAxisAllignedBoundingBox_h
#define AGLKAxisAllignedBoundingBox_h

#import <GLKit/GLKit.h>

//Type that defines a bounding box. No vertex in contained objects has X coordinate less than min.x or X coordinate greater than max.x. The same is true for Y and Z coordinates relative to min.y, min.z, max.y and max.z.
typedef struct{
    GLKVector3 min;
    GLKVector3 max;
}AGLKAxisAllignedBoundingBox;

#endif /* AGLKAxisAllignedBoundingBox_h */
