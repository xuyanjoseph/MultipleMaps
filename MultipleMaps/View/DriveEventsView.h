//
//  DriveEventsView.h
//  168CarDVR
//
//  Created by dev on 2018/5/7.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteTrailData.h"

@interface DriveEventsView : UIView

- (instancetype)initWithFrame:(CGRect)frame srcArr:(NSDictionary *)srcDic;

- (void)refreshEventView:(RouteTrailData *)routeDtM;
- (void)refreshInfoView:(RouteTrailData *)routeDtM;

@end
