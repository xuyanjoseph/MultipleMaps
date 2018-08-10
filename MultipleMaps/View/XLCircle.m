//
//  Circle.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircle.h"
#import "UIColor+HEX.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = 1.0f;

@interface XLCircle ()
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    CAGradientLayer *_gradientLayer;
    //UIImageView* _endPoint;//在终点位置添加一个点
}
@end

@implementation XLCircle


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self buildLayout];
    }
    return self;
}

-(void)buildLayout
{
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:1.5f*M_PI clockwise:YES];
    
    //添加背景圆环

    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
//    backLayer.strokeColor  = [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1].CGColor;
    
    backLayer.strokeColor  = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor colorWithHexString:@"#cccccc"] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    _gradientLayer =  [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(34, 139, 34) CGColor],(id)[RGB(34, 139, 34) CGColor], nil]];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
    
    
    //用于显示结束位置的小点
//    _endPoint = [[UIImageView alloc] init];
//    _endPoint.frame = CGRectMake(0, 0, _lineWidth - endPointMargin*2,_lineWidth - endPointMargin*2);
//    _endPoint.hidden = true;
//    _endPoint.backgroundColor = [UIColor blackColor];
//    _endPoint.image = [UIImage imageNamed:@"endPoint"];
//    _endPoint.layer.masksToBounds = true;
//    _endPoint.layer.cornerRadius = _endPoint.bounds.size.width/2;
//    [self addSubview:_endPoint];
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    
    [self configProLayerColor];
    
    
    [self updateEndPoint];
    [_progressLayer removeAllAnimations];
}

- (void)configProLayerColor {
    float intProValue = _progress * 100;
    
    UIColor *graStokeColor = [self generateColrWithProValue:intProValue]; //[[UIColor alloc] init];
    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[graStokeColor CGColor],(id)[graStokeColor CGColor], nil]];
}

- (UIColor *)generateColrWithProValue:(float)proValue {
//    UIColor *graStokeColor = [[UIColor alloc] init];
    UIColor *graStokeColor = [UIColor blueColor];
    
    if (proValue >= 0 && proValue < 60) {
        graStokeColor = [UIColor colorWithHexString:@"#fd373b"];

    } else if (proValue >= 60 && proValue < 80) {
        graStokeColor = [UIColor colorWithHexString:@"#fb9a02"];

    } else if (proValue >= 80 && proValue <= 100) {
        graStokeColor = [UIColor colorWithHexString:@"#03acfa"];

    }
    
    return graStokeColor;
}

//更新小点的位置
-(void)updateEndPoint
{
    //转成弧度
    CGFloat angle = M_PI*2*_progress;
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    
    //更新圆环的frame
//    CGRect rect = _endPoint.frame;
//    rect.origin.x = x + endPointMargin;
//    rect.origin.y = y + endPointMargin;
//    _endPoint.frame = rect;
    //移动到最前
//    [self bringSubviewToFront:_endPoint];
//    _endPoint.hidden = false;
//    if (_progress == 0 || _progress == 1) {
//        _endPoint.hidden = true;
//    }
}

@end
