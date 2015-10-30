//
//  SecondViewController.m
//  Animation
//
//  Created by Scott_Mr on 15/10/29.
//  Copyright © 2015年 Scott_Mr. All rights reserved.
//

#import "SecondViewController.h"

// 角度转弧度
#define angle2Radian(angle) ((angle) / 180.0 * M_PI)

@interface SecondViewController ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) NSInteger    index;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.width = self.view.bounds.size.width;
    self.height = self.view.bounds.size.height;
    self.view.userInteractionEnabled = NO;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:imgView];
    self.imgView = imgView;

    
    switch (self.animationType) {
        case AnimationTypeUIView:{
            [self viewAnimation];
        }
            break;
        case AnimationTypeBasic:{
            [self basicAnimation];
        }
            break;
        case AnimationTypeKeyframe:{
            [self keyframeAnimation];
        }
            break;
        case AnimationTypeTransiton:{
            self.view.userInteractionEnabled = YES;
            
            self.imgView.frame = CGRectMake(0, 64, self.width, 200);
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%02ld",self.index+1]];
        }
            break;
        case AnimationTypeGroup:{
            [self groupAnimation];
        }
            break;
        default:
            break;
    }
}

/*-------------------------------------UIView动画----------------------------*/
- (void)viewAnimation
{
    self.imgView.frame = CGRectMake(0, 80, 100, 100);
    // 延时1秒调用
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        // 模拟弹簧效果
        [UIView animateWithDuration:2.0f delay:0.0 usingSpringWithDamping:0.2f initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imgView.transform = CGAffineTransformMakeTranslation(0, 200);
        } completion:^(BOOL finished) {
            
        }];
    });
}

/*-------------------------------------基础动画----------------------------*/
#pragma mark - 基础动画
- (void)basicAnimation
{
    self.imgView.frame = CGRectMake(self.view.center.x, self.view.center.y, 50, 50);
    
    // 3D旋转
    [self addTransform];
    // 缩放
    [self addScale];
}

// 改变transform(3D旋转)
- (void)addTransform
{
    // 创建一个基础动画对象
    CABasicAnimation *basicAnimation = [[CABasicAnimation alloc] init];
    // 设置动画属性
    basicAnimation.duration = 2.0f;
    // 旋转
    basicAnimation.keyPath = @"transform";
    CATransform3D transForm3D = CATransform3DMakeRotation(M_PI, 1, -1, 0);
    basicAnimation.toValue = [NSValue valueWithCATransform3D:transForm3D];
    // 动画执行完毕是否删除动画
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    // 动画重复次数
    basicAnimation.repeatCount = MAXFLOAT;
    
    [self.imgView.layer addAnimation:basicAnimation forKey:nil];
}

// 缩放
- (void)addScale
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    anim.keyPath = @"transform.scale";
    // 3.放大3倍
    anim.toValue = @3;
    anim.duration = 2.0;
    
    // 动画执行完毕后不要删除动画
    anim.removedOnCompletion = NO;
    // 保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    
    // 3.添加动画
    [self.imgView.layer addAnimation:anim forKey:nil];
}

/*-------------------------------------关键帧动画----------------------------*/
#pragma mark - 关键帧动画
- (void)keyframeAnimation
{
    self.imgView.frame = CGRectMake((self.width-100)*0.5, (self.height-164)*0.5, 100, 100);
    
    // 添加图标抖动动画
    [self shakeAnimation];
    [self animationWithKeyPath];
}

// 图标抖动动画
- (void)shakeAnimation
{
    // 1.创建动画对象
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    // 2.设置动画属性
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(angle2Radian(-40)),@(angle2Radian(40)),@(angle2Radian(-40))];
    animation.duration = 0.35;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.imgView.layer addAnimation:animation forKey:@"shake"];
}

// 沿着路径动画
- (void)animationWithKeyPath
{
    // 创建动画对象
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    // 设置动画属性
    animation.keyPath = @"position";
    animation.duration = 2.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, _imgView.center.x, _imgView.center.y, 100, 0, 2*M_PI, NO);
    animation.path = path;
    CGPathRelease(path);
    
    // 设置动画节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.imgView.layer addAnimation:animation forKey:nil];
}

/*-------------------------------------转场动画----------------------------*/
#pragma mark - 转场动画  （PS这个动画不好演示，所以加了个touchesBegan方法手动来触发）
- (void)transitionAnimation
{
    ++self.index;
    if (self.index == 6) {
        self.index = 0;
    }
    
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%02ld",self.index+1]];
    self.imgView.image = img;
    
    CATransition *transiton = [CATransition animation];
    transiton.type = @"pageCurl";
    transiton.subtype = kCATransitionFromBottom;
    transiton.duration = 0.35;
    [self.imgView.layer addAnimation:transiton forKey:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self transitionAnimation];
}

/*-------------------------------------组动画----------------------------*/
#pragma mark - 组动画
- (void)groupAnimation
{
    self.imgView.frame = CGRectMake((self.width-100)*0.5, (self.height-164)*0.5, 100, 100);

    // 1.创建旋转动画对象
    CABasicAnimation *rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation";
    //旋转的度数M_PI ＝ 180度
    rotate.toValue = @(M_PI*2);
    
    // 2.创建缩放动画对象
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    //缩放的比例大小 >1放大  <1缩小
    scale.toValue = @(0.5);
    
    // 3.平移动画
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"transform.translation";
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(20, 100)];
    
    // 4.将所有的动画添加到动画组中
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[rotate, scale, move];
    group.duration = 2.0;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.imgView.layer addAnimation:group forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
