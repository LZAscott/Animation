//
//  SecondViewController.h
//  Animation
//
//  Created by Scott_Mr on 15/10/29.
//  Copyright © 2015年 Scott_Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AnimationTypeUIView = 0,
    AnimationTypeBasic,
    AnimationTypeKeyframe,
    AnimationTypeTransiton,
    AnimationTypeGroup
} AnimationType;

@interface SecondViewController : UIViewController

@property (nonatomic, assign) AnimationType animationType;

@end
