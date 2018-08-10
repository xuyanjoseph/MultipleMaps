//
//  GeneralMethods.m
//  168CarDVR
//
//  Created by dev on 2018/5/24.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "GeneralMethods.h"
#import "MBProgressHUD.h"

@implementation GeneralMethods

+ (void)configHUD:(UIView *)view labText:(NSString *)text delay:(NSTimeInterval)timeDelay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:timeDelay];
}

+ (CGFloat)configureMapTopVHt {
    NSInteger screenWidInt = (NSInteger)(floor(SCREEN_WIDTH));
    
    UIFont *textFont;
    UIFont *infoFont;
    
    switch (screenWidInt) {
        case 320:
            textFont = [UIFont systemFontOfSize:10];
            infoFont = [UIFont boldSystemFontOfSize:10];
            break;
        case 375:
            textFont = [UIFont systemFontOfSize:12];
            infoFont = [UIFont boldSystemFontOfSize:12];
            break;
        case 414:
            textFont = [UIFont systemFontOfSize:14];
            infoFont = [UIFont boldSystemFontOfSize:14];
            break;
        default:
            break;
    }
    
    NSString *defStr1 = @"疲劳驾驶";
    NSDictionary *nameLbDic1 = @{NSFontAttributeName: textFont};
    CGRect nameLbRect = [defStr1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:nameLbDic1
                                       context:nil];
    CGFloat imgWid = nameLbRect.size.width - 10;
    CGFloat totalHt = 10 + imgWid + 5 + nameLbRect.size.height + 10;
    
    return totalHt;
}

@end
