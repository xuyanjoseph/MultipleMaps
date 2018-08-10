//
//  DriveEventsView.m
//  168CarDVR
//
//  Created by dev on 2018/5/7.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "DriveEventsView.h"
#import "UIView+PPBadgeView.h"
#import "UIColor+HEX.h"

CGFloat const leftPadding = 1;
CGFloat const subLeftPadding = 5;
CGFloat const subMidPadding = 5;
CGFloat const subBottomPadding = 10;

@interface DriveEventsView()
{
    CGFloat driActBtnWidth;
    CGFloat driActBtnHeight;
    CGFloat subBtnPadding;
    
    UIFont *textFont;
    UIFont *infoFont;
    UIFont *badgeFont;
    
    NSArray *driActImgArr;
    CGRect nameLbRect;
    CGRect infoLbRect;
    CGRect badgeRect;
    CGFloat offset;
}

@property (nonatomic, strong) NSArray *eventArr;
@property (nonatomic, strong) NSArray *evtInfoArr;

@property (nonatomic, assign) BOOL ifContainImgs;
@property (nonatomic, assign) BOOL ifContainBadges;

@end

@implementation DriveEventsView

- (instancetype)initWithFrame:(CGRect)frame srcArr:(NSDictionary *)srcDic {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.alpha = 0.9;
    
    self.evtInfoArr = nil;
    
    self.eventArr = (NSArray *)[srcDic objectForKey:@"events"];
    self.ifContainImgs = ((NSNumber *)[srcDic objectForKey:@"image"]).boolValue;
    self.ifContainBadges = ((NSNumber *)[srcDic objectForKey:@"badge"]).boolValue;
    
    if ([srcDic.allKeys containsObject:@"eventInfo"]) {
        self.evtInfoArr = (NSArray *)[srcDic objectForKey:@"eventInfo"];
    }
    
    [self configLayoutParas];
    [self initializeUI];
    
    return self;
}

#pragma mark - Helpers

- (UIButton *)createSubBtnWithIndex:(NSUInteger)index {
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    subBtn.backgroundColor = [UIColor clearColor];
//    CGRect evtRect = CGRectMake(leftPadding + index*(driActBtnWidth+subBtnPadding), 0, driActBtnWidth, driActBtnHeight);
    CGRect evtRect = CGRectMake(index*(driActBtnWidth+subBtnPadding), 0, driActBtnWidth, driActBtnHeight);
    
    CGFloat infoOriX = (SCREEN_WIDTH - self.eventArr.count*driActBtnWidth)/2;
    CGRect infoRect = CGRectMake(infoOriX + index*driActBtnWidth, 0, driActBtnWidth, driActBtnHeight);
    subBtn.frame = (self.ifContainImgs ? evtRect: infoRect);
    subBtn.tag = index+1;
    return subBtn;
}

- (void)initializeUI {
    NSUInteger eventArrCnt = self.eventArr.count;
//    subBtnPadding = (self.bounds.size.width - 2 * leftPadding - eventArrCnt * driActBtnWidth) / (eventArrCnt - 1);
    subBtnPadding = (self.bounds.size.width - eventArrCnt * driActBtnWidth) / (eventArrCnt - 1);
    
    for (NSUInteger i = 0, j = eventArrCnt; i < j; i++) {
        UIButton *subBtn = [self createSubBtnWithIndex:i];
        [self configSubBtnUI:subBtn];
        [self addSubview:subBtn];
    }
}

- (void)configLayoutParas {
    
    NSInteger screenHtInt = (NSInteger)(floor(SCREEN_WIDTH));
    
    switch (screenHtInt) {
        case 320:
            textFont = [UIFont systemFontOfSize:10];
            infoFont = [UIFont boldSystemFontOfSize:10];
            badgeFont = [UIFont boldSystemFontOfSize:7];
            offset = 6;
            break;
        case 375:
            textFont = [UIFont systemFontOfSize:12];
            infoFont = [UIFont boldSystemFontOfSize:12];
            badgeFont = [UIFont boldSystemFontOfSize:8];
            offset = 7;
            break;
        case 414:
            textFont = [UIFont systemFontOfSize:14];
            infoFont = [UIFont boldSystemFontOfSize:14];
            badgeFont = [UIFont boldSystemFontOfSize:9];
            offset = 8;
            break;
        default:
            break;
    }
    
    NSString *defStr1 = @"疲劳驾驶";
    NSDictionary *nameLbDic1 = @{NSFontAttributeName: textFont};
    nameLbRect = [defStr1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:nameLbDic1
                         context:nil];
    
    NSString *defStr2 = @"123km/h";
    NSDictionary *nameLbDic2 = @{NSFontAttributeName: infoFont};
    infoLbRect = [defStr2 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:nameLbDic2
                                      context:nil];
    
    driActBtnWidth = (self.ifContainImgs ? nameLbRect.size.width : (SCREEN_WIDTH * 22.7 / 100));
    driActBtnHeight = self.bounds.size.height;
    
    driActBtnWidth = ceilf(driActBtnWidth);
    driActBtnHeight = ceilf(driActBtnHeight);
    
    if (self.ifContainImgs) {
        driActImgArr = @[@"Overspeed", @"FatigueDriving", @"SharpCornering", @"SharpAcceleration", @"SharpDeceleration"];
    }
    
}

- (void)configSubBtnUI:(UIButton *)actBtn {
    
    if (self.ifContainImgs) {
        CGFloat actLbHt = nameLbRect.size.height;
        CGFloat actImgWid = driActBtnWidth - 2 * subLeftPadding;
        CGFloat actImgOriY = driActBtnHeight - actImgWid - subMidPadding - actLbHt - subBottomPadding;
        
        NSString *imgBaseStr = (NSString *)[driActImgArr objectAtIndex:(actBtn.tag - 1)];
        UIImageView *actImgV = [[UIImageView alloc] initWithFrame:(CGRect){subLeftPadding, 10, actImgWid, actImgWid}];
        actImgV.tag = actBtn.tag * 100;
        actImgV.image = [UIImage imageNamed:imgBaseStr];
        actImgV.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imgBaseStr, @"_yes"]];
        [actBtn addSubview:actImgV];
        
        UILabel *actLb = [[UILabel alloc] initWithFrame:(CGRect){0, driActBtnHeight - subBottomPadding - actLbHt, driActBtnWidth, actLbHt}];
        actLb.backgroundColor = [UIColor whiteColor];
        actLb.textColor = [UIColor colorWithHexString:@"#999999"];
        actLb.font = textFont;
        actLb.textAlignment = NSTextAlignmentCenter;
        actLb.text = (NSString *)[self.eventArr objectAtIndex:(actBtn.tag - 1)];
        [actBtn addSubview:actLb];
        
        if (self.ifContainBadges) {

            CGFloat badgeSize = 2 * offset;
            CGFloat badgeOriY = actImgV.frame.origin.y - offset;
            badgeRect = CGRectMake(actImgV.frame.origin.x + actImgWid - offset - 2, badgeOriY, badgeSize, badgeSize);
            [actBtn pp_configBadgeWithNumber:@0 andFrame:badgeRect andFont:badgeFont];
        }
    } else if (self.evtInfoArr) {
        CGFloat infoLbHt = infoLbRect.size.height;
        CGFloat nameLbHt = nameLbRect.size.height;
        CGFloat infoLbOriY = (actBtn.bounds.size.height - nameLbHt - infoLbHt - subMidPadding)/2;
        
        infoLbHt = ceilf(infoLbHt);
        nameLbHt = ceilf(nameLbHt);
        infoLbOriY = ceilf(infoLbOriY);
        
        UILabel *infoLb = [[UILabel alloc] initWithFrame:(CGRect){0, infoLbOriY, driActBtnWidth, infoLbHt}];
        infoLb.backgroundColor = [UIColor whiteColor];
        infoLb.textColor = [UIColor colorWithHexString:@"#03ACFA"];
        infoLb.font = infoFont;
        infoLb.tag = actBtn.tag * 10;
        [actBtn addSubview:infoLb];
        
        UILabel *actLb = [[UILabel alloc] initWithFrame:(CGRect){0, infoLbOriY + infoLbHt + subMidPadding, driActBtnWidth, nameLbHt}];
        actLb.backgroundColor = [UIColor whiteColor];
        actLb.textColor = [UIColor colorWithHexString:@"#999999"];
        actLb.font = textFont;

        actLb.text = (NSString *)[self.eventArr objectAtIndex:(actBtn.tag - 1)];
        [actBtn addSubview:actLb];
        
        switch (actBtn.tag) {
            case 1:
                infoLb.textAlignment = NSTextAlignmentLeft;
                actLb.textAlignment = NSTextAlignmentLeft;
                break;
            case 2:
            case 3:
                infoLb.textAlignment = NSTextAlignmentCenter;
                actLb.textAlignment = NSTextAlignmentCenter;
                break;
            case 4:
                infoLb.textAlignment = NSTextAlignmentRight;
                actLb.textAlignment = NSTextAlignmentRight;
                break;
            default:
                break;
        }
    }
    
}

- (void)refreshEventView:(RouteTrailData *)routeDtM {
    NSInteger AcceCount = routeDtM.harsh_acce_count;
    NSInteger DeceCount = routeDtM.harsh_dece_count;
    NSInteger TurnCount = routeDtM.harsh_turn_count;
    
    for (NSUInteger i = 0; i < 3; i++) {
        UIButton *actBtn = (UIButton *)[self viewWithTag:(i + 3)];
        UILabel *infoLb = (UILabel *)[actBtn viewWithTag:((i + 3) * 100)];
        switch (i) {
            case 0:
            {
                if (TurnCount > 0) {
                    [self configInfoLb:infoLb andActBtn:actBtn withEvtCount:TurnCount];
                }
            }
                
                break;
            case 1:
            {
                if (AcceCount > 0) {
                    [self configInfoLb:infoLb andActBtn:actBtn withEvtCount:AcceCount];
                }
            }
                break;
            case 2:
            {
                if (DeceCount > 0) {
                    [self configInfoLb:infoLb andActBtn:actBtn withEvtCount:DeceCount];
                }
            }
                break;
            default:
                break;
        }

    }
}

- (void)configInfoLb:(UILabel *)infoLb andActBtn:(UIButton *)actBtn withEvtCount:(NSInteger)evtCount {
    CGFloat wid = [self calcTextWidth:[NSString stringWithFormat:@"%ld", (long)evtCount]];
    CGRect rect = CGRectMake(badgeRect.origin.x, badgeRect.origin.y, wid, badgeRect.size.height);
    infoLb.highlighted = YES;
    [actBtn pp_configBadgeWithNumber:@(evtCount)
                            andFrame:rect
                             andFont:badgeFont];
}

- (void)refreshInfoView:(RouteTrailData *)routeDtM {
    for (NSUInteger i = 0, j = self.eventArr.count; i < j; i++) {
        UIButton *actBtn = (UIButton *)[self viewWithTag:(i + 1)];
        UILabel *infoLb = (UILabel *)[actBtn viewWithTag:((i + 1) * 10)];
        
        switch (i) {
            case 0:
            {
                float mileageFloat = ((float)routeDtM.mileage)/1000;
                float mileageNum = round(mileageFloat * 100)/100;
                infoLb.text = [NSString stringWithFormat:@"%.1lf%@", mileageNum, @"km"];
            }
                break;
            case 1:
            {
                NSInteger time = routeDtM.time;
                if (time >= 3600) {
                    NSInteger hr = time/3600;
                    NSInteger sec = time % 3600;
                    NSInteger min = sec / 60;
                    if (min == 0) {
                        infoLb.text = [NSString stringWithFormat:@"%ld%@", hr, @"h"];
                    } else {
                        infoLb.text = [NSString stringWithFormat:@"%ld%@%ld%@", hr, @"h", min, @"min"];
                    }
                    
                } else {
                    
                    infoLb.text = [NSString stringWithFormat:@"%ld%@", time/60, @"min"];
                }
                
            }
                break;
            case 2:
            {
                infoLb.text = [NSString stringWithFormat:@"%.1f%@", routeDtM.avg_speed, @"km/h"];
            }
                break;
            case 3:
            {
                infoLb.text = [NSString stringWithFormat:@"%.1f%@", routeDtM.max_speed, @"km/h"];
            }
                break;
            default:
                break;
        }
    }
    
}

- (CGFloat)calcTextWidth:(NSString *)text {
    if (text.intValue >= 100) {
        text = @"99+";
    }
    UIFont *font = [UIFont systemFontOfSize:8];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,12)     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return (text.intValue >= 100 ? rect.size.width-4 : rect.size.width);
}

@end
