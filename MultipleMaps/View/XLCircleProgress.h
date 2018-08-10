//
//  CircleView.h
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SuperViewClassType) {
    SuperViewClassType_RouteHeaderView = 0,
    SuperViewClassType_RATableViewCell = 1
};

@interface XLCircleProgress : UIView
//百分比
@property (assign,nonatomic) float progress;
@property (nonatomic, assign) SuperViewClassType superVClassType;

@end
