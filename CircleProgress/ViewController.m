//
//  ViewController.m
//  CircleProgress
//
//  Created by 张雷 on 16/10/26.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"

@interface ViewController ()
<
SuperViewDequeueDelegate
>
{
    CircleProgressView *circleV;
    UISlider *proV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    circleV = [[CircleProgressView alloc] initWithView:self.view];
    [self.view addSubview:circleV];
    circleV.delegate = self;
    
    UISlider *pro = [self addProgressView];
    circleV.progress = pro.value;
}


- (UISlider *)addProgressView{
    proV = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2., self.view.frame.size.height-100, 300, 40)];
    proV.minimumValue = 0.;
    proV.maximumValue = 1.;
    proV.tintColor = [UIColor darkGrayColor];
    [proV addTarget:self action:@selector(progressDidChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:proV];
    return proV;
}

- (void)progressDidChange{
    circleV.progress = proV.value;
}


/**
 从父视图中复用进度条
 
 @return 环形进度条
 */
- (CircleProgressView *)dequeueCircleProgressView:(UIView *)superView{
    for (UIView *subV in superView.subviews) {
        if ([subV isKindOfClass:[CircleProgressView class]]) {
            CircleProgressView *circle = (CircleProgressView *)subV;
            return circle;
        }else{
            return nil;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
