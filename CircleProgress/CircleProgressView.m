//
//  CircleProgressView.m
//  CircleProgress
//
//  Created by 张雷 on 16/10/26.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//


#define KRGBCOLOR(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define KBGGRAYCOLOR KRGBCOLOR(231,231,231,1)
#define KAPPLECOLOR(R,G,B,A) [UIColor colorWithRed:R green:G blue:B alpha:A]

#import "CircleProgressView.h"

@interface CircleProgressView(){
    CAShapeLayer *bgProLayer;
    CAShapeLayer *frontProLayer;
    
    UIColor *firstStatusColor;      //= KRGBCOLOR(239, 117, 87, 1);
    UIColor *secondStatusColor;     //= KRGBCOLOR(239, 159, 95, 1);
    UIColor *thirdStatusColor;      //= KRGBCOLOR(109, 196, 137, 1);
    UIColor *fourthStatusColor;     //= KRGBCOLOR(148, 158, 245, 1);
    UIColor *endStatusColor;        //= KRGBCOLOR( 63, 137, 246, 1);  我自己随便给的最终颜色，你问问设计应该给个什么色值。
}

@end

@implementation CircleProgressView

- (instancetype)initWithView:(UIView *)superView{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        firstStatusColor = KRGBCOLOR(255, 109, 75, 1);
        secondStatusColor = KRGBCOLOR(255, 156, 71, 1);
        thirdStatusColor = KRGBCOLOR(109, 196, 137, 1);
        fourthStatusColor = KRGBCOLOR(148, 158, 245, 1);
        endStatusColor = KRGBCOLOR( 63, 137, 246, 1);
        _width = 180.;
        _borderWidth = 10.;
        self.frame = CGRectMake((superView.frame.size.width-_width)/2., (superView.frame.size.height-_width)/2., _width, _width);
        
        [self drawCircle];
    }
    return self;
}


- (void)setWidth:(CGFloat)width{
    _width = width;
    [self refreshFrameByWid:width];
}


- (void)refreshFrameByWid:(CGFloat)width{
    CGPoint center = CGPointMake(width/2., width/2.);
    self.frame = CGRectMake(0, 0, width, width);
    self.center = center;
    [self setNeedsDisplay];
    
    [self drawCircle];
}


- (void)drawCircle{
    CGPoint center = CGPointMake(_width/2., _width/2.);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center radius:_width/2. startAngle:5/6.*M_PI endAngle:M_PI/6. clockwise:YES];
    
    aPath.lineWidth = _borderWidth;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinMiter;
    
    if (!bgProLayer) {
        bgProLayer = [CAShapeLayer layer];
        bgProLayer.backgroundColor = [UIColor clearColor].CGColor;
        bgProLayer.frame = CGRectMake(0, 0, _width, _width);
        bgProLayer.position = center;
        bgProLayer.path = aPath.CGPath;
        bgProLayer.lineWidth = _borderWidth;
        bgProLayer.fillColor = [UIColor clearColor].CGColor;
        bgProLayer.strokeColor = KBGGRAYCOLOR.CGColor;
        //bgProLayer.lineCap = @"square";
        [self.layer addSublayer:bgProLayer];
    }else{
        bgProLayer.frame = CGRectMake(0, 0, _width, _width);
        bgProLayer.position = center;
        bgProLayer.path = aPath.CGPath;
        bgProLayer.lineWidth = _borderWidth;
    }
    
    if (!frontProLayer) {
        frontProLayer = [CAShapeLayer layer];
        frontProLayer.backgroundColor = bgProLayer.backgroundColor;
        frontProLayer.frame = bgProLayer.frame;
        frontProLayer.position = bgProLayer.position;
        frontProLayer.path = bgProLayer.path;
        frontProLayer.lineWidth = bgProLayer.lineWidth;
        frontProLayer.fillColor = bgProLayer.fillColor;
        frontProLayer.strokeColor = firstStatusColor.CGColor;
        //frontProLayer.lineCap = @"round";
        [bgProLayer addSublayer:frontProLayer];
    }else{
        frontProLayer.frame = bgProLayer.frame;
        frontProLayer.position = bgProLayer.position;
        frontProLayer.path = bgProLayer.path;
        frontProLayer.lineWidth = bgProLayer.lineWidth;
    }
}


/**
 在view中显示环形进度条

 @param superView 父视图
 */
- (void)showInView:(UIView *)superView{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(dequeueCircleProgressView:)]) {
            CircleProgressView *circlePro = [_delegate dequeueCircleProgressView:superView];
            if (nil == circlePro) {
                circlePro = [[CircleProgressView alloc] initWithView:superView];
                [superView addSubview:superView];
            }
        }
    }
    
    self.hidden = NO;
    [superView bringSubviewToFront:self];
}


// 计算每一帧对应的颜色
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    //NSLog(@"progress:%f",progress);
    frontProLayer.strokeEnd = progress;
    
    if (progress>0) {
        //frontProLayer.strokeColor = firstStatusColor.CGColor;
        frontProLayer.strokeColor = [self resetColor:firstStatusColor toColor:secondStatusColor withProgress:0.].CGColor;
    }
    if (progress>0.25) {
//        frontProLayer.strokeColor = secondStatusColor.CGColor;
        frontProLayer.strokeColor = [self resetColor:secondStatusColor toColor:thirdStatusColor withProgress:0.25].CGColor;
    }
    if (progress>0.5) {
//        frontProLayer.strokeColor = thirdStatusColor.CGColor;
        frontProLayer.strokeColor = [self resetColor:thirdStatusColor toColor:fourthStatusColor  withProgress:0.5].CGColor;
    }
    if (progress>0.75) {
//        frontProLayer.strokeColor = fourthStatusColor.CGColor;
        frontProLayer.strokeColor = [self resetColor:fourthStatusColor toColor:endStatusColor withProgress:0.75].CGColor;
    }
}



- (UIColor *)resetColor:(UIColor *)fromColor toColor:(UIColor *)toColor withProgress:(CGFloat)pro{
   
    NSArray *fromRGB = [CircleProgressView getRGBWithColor:fromColor];
    NSArray *toRGB = [CircleProgressView getRGBWithColor:toColor];
    
    float rgb[3] = {239/255.,117/255.,87/255.};
    
    for (short i=0; i<3; i++) {
        float t = [toRGB[i] floatValue];
        float f = [fromRGB[i] floatValue];
        float v = f+(t-f)*(_progress-pro)*4;
        rgb[i] = v;
    }
    
    //NSLog(@"\n%.1f %.1f %.1f",rgb[0],rgb[1],rgb[2]);
    return KAPPLECOLOR(rgb[0], rgb[1], rgb[2], 1);
}


+ (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}



- (void)hidden{
    self.hidden = YES;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}



@end
