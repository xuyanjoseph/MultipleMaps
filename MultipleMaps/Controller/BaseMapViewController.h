//
//  BaseMapViewController.h
//  168CarDVR
//
//  Created by dev on 2018/7/19.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "BaseViewController.h"
#import "RouteTrailData.h"
#import "DriveEventsView.h"
#import "XLCircleProgress.h"

@interface BaseMapViewController : BaseViewController

@property (nonatomic, strong) RouteTrailData *routeTrailDt;
@property (nonatomic, strong) UIView *subMapView;

- (void)sendReqToGetRouteTrailWithMapType:(NSString *)mapType andBlock:(void (^)(NSArray *))overBlock;

@end
