//
//  CircleProgressView.h
//  CircleProgress
//
//  Created by 张雷 on 16/10/26.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, STATUS_TYPE) {
    STATUS_TYPE_NORMAL=1,   // 普通
    STATUS_TYPE_YINPAI,     // 银牌
    STATUS_TYPE_JINPAI,     // 金牌
    STATUS_TYPE_ZUANSHI     // 钻石
};



@class CircleProgressView;

@protocol SuperViewDequeueDelegate <NSObject>

- (CircleProgressView *)dequeueCircleProgressView:(UIView *)superView;

@end

@interface CircleProgressView : UIView


/**
 环形的直径
 */
@property (nonatomic, assign) CGFloat width;    // default is 120

@property (nonatomic, assign) CGFloat borderWidth;  // default is 5.0

@property (nonatomic, assign) CGFloat progress; // default is 0.618


@property (nonatomic, assign) id<SuperViewDequeueDelegate> delegate;
/**
 在view中显示环形进度条
 
 @param superView 父视图
 */
- (void)showInView:(UIView *)superView;
- (instancetype)initWithView:(UIView *)superView;

@end
