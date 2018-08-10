//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"
#import "UIColor+HEX.h"

CGFloat const perTxtFont = 27;
NSString * const perTxtColor = @"#cccccc";

@implementation XLCircleProgress
{
    XLCircle* _circle;
    UILabel *_percentLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


-(void)initUI
{
//    float lineWidth = 0.1*self.bounds.size.width;
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _percentLabel.textColor = [UIColor colorWithHexString:perTxtColor];
    _percentLabel.backgroundColor = [UIColor whiteColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = [UIFont boldSystemFontOfSize:perTxtFont];
    _percentLabel.text = @"0";
    [self addSubview:_percentLabel];
    
//    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth];
    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:3];
    [self addSubview:_circle];
}

#pragma mark - Helpers

-(NSMutableAttributedString *)configAppearanceWithProgress:(float)progress {
    
    NSString *progStr = [NSString stringWithFormat:@"%.2f%@",progress, @"分"];
    NSRange pointRange = [progStr rangeOfString:@"."];
    NSUInteger pointLoc = -1;
    if (pointRange.location != -1) {
        pointLoc = pointRange.location;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:progStr];
    NSUInteger totalLen = attrStr.length;
    
    UIColor *numColor = [_circle generateColrWithProValue:progress];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:
     numColor range:NSMakeRange(0, totalLen)];

    NSInteger screenWidInt = (NSInteger)(floor(SCREEN_WIDTH));
    
    CGFloat firFontSize = 0.0;
    CGFloat secFontSize = 0.0;
    
    switch (screenWidInt) {
        case 320:
            firFontSize = 14.0f;
            secFontSize = 11.0f;
            break;
        case 375:
            firFontSize = 15.0f;
            secFontSize = 12.0f;
            break;
        case 414:
            firFontSize = 16.0f;
            secFontSize = 13.0f;
            break;
        default:
            break;
    }
    
    
    UIFont *firAttrFont = [UIFont systemFontOfSize:(SuperViewClassType_RouteHeaderView == self.superVClassType ?firFontSize:12.0f)];
    UIFont *secAttrFont = [UIFont systemFontOfSize:(SuperViewClassType_RouteHeaderView == self.superVClassType ?secFontSize:10.0f)];
    
    [attrStr addAttribute:NSFontAttributeName value:firAttrFont range:NSMakeRange(0, pointLoc)];
    [attrStr addAttribute:NSFontAttributeName value:secAttrFont range:NSMakeRange(pointLoc, totalLen - pointLoc)];
    
    return attrStr;
}

#pragma mark Setter方法
-(void)setProgress:(float)progress
{
    CGFloat proValue = progress / 100;
    _progress = proValue;
    _circle.progress = proValue;
    
    if (progress > 0) {
        _percentLabel.attributedText = [self configAppearanceWithProgress:progress];
    }
}

@end
