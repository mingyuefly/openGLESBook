//
//  ViewController.h
//  OPENGLES_CH9_1
//
//  Created by Gguomingyue on 2017/10/19.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController<UIAccelerometerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fpsField;
- (IBAction)takeShouldCullFrom:(UISwitch *)sender;


@end

