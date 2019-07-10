//
//  ViewController.h
//  OPENGLES_CH7_3
//
//  Created by Gguomingyue on 2017/10/14.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController

- (IBAction)takeAngle0From:(UISlider *)sender;
- (IBAction)takeAngle1From:(UISlider *)sender;
- (IBAction)takeAngle2From:(UISlider *)sender;
- (IBAction)takeRigidSkinFrom:(UISwitch *)sender;

@end

