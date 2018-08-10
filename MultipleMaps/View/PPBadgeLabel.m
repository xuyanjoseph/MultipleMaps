//
//  PPBadgeLabel.m
//  PPBadgeViewObjc
//
//  Created by AndyPang on 2017/6/17.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 * Weibo : jkpang-庞 ( http://weibo.com/jkpang )
 * Email : jkpang@outlook.com
 * QQ 群 : 323408051
 * GitHub: https://github.com/jkpang
 *
 *********************************************************************************
 */

#import "PPBadgeLabel.h"
#import "UIView+PPBadgeView.h"
#import "UIColor+HEX.h"

NSString * const badgeTxtClr = @"#ffffff";
NSString * const badgeLayerInitClr = @"#666666";
NSString * const badgeLayerClr = @"#fd373b";

//CGFloat const badgeTxtFont = 8;

@interface PPBadgeLabel ()

@property (nonatomic, strong) UIFont *badgeTxtFont;

@end

@implementation PPBadgeLabel

+ (instancetype)defaultBadgeLabel
{
    // 默认为系统tabBarItem的Badge大小
    return [[PPBadgeLabel alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
}

+ (instancetype)defaultBadgeLabelWithFrame:(CGRect)defRect {
    return [[PPBadgeLabel alloc] initWithFrame:defRect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

+ (instancetype)defaultBadgeLabelWithFrame:(CGRect)defRect andFont:(UIFont *)font {
//    return [[PPBadgeLabel alloc] initWithFrame:defRect];
    return [[PPBadgeLabel alloc] initWithFrame:defRect andFont:font];
}

- (instancetype)initWithFrame:(CGRect)frame andFont:(UIFont *)font
{
    if (self = [super initWithFrame:frame]) {
        self.badgeTxtFont = font;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.textColor = [UIColor colorWithHexString:badgeTxtClr];
    self.font = self.badgeTxtFont;
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.cornerRadius = self.p_height * 0.5;
    self.layer.masksToBounds = YES;
    
//    self.backgroundColor = [UIColor colorWithRed:1.00 green:0.17 blue:0.15 alpha:1.00];
//    self.layer.backgroundColor = [UIColor colorWithHexString:badgeLayerInitClr].CGColor;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // 根据内容调整label的宽度
    CGFloat stringWidth = [self widthForString:text font:self.font height:self.p_height];
    if (self.p_height > stringWidth + self.p_height*10/18) {
        self.p_width = self.p_height;
        return;
    }
    self.p_width = self.p_height*5/18/*left*/ + stringWidth + self.p_height*5/18/*right*/;
}

- (CGFloat)widthForString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

@end
