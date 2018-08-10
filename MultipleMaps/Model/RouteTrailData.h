//
//  RouteTrailData.h
//  168CarDVR
//
//  Created by dev on 2018/5/9.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripCellData.h"

@interface RouteTrailData : NSObject

@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *trip_id;

@property (nonatomic, strong) NSNumber *start_time;

@property (nonatomic, assign) NSInteger mileage;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger harsh_acce_count;
@property (nonatomic, assign) NSInteger harsh_dece_count;
@property (nonatomic, assign) NSInteger harsh_turn_count;

@property (nonatomic, assign) float avg_speed;
@property (nonatomic, assign) float max_speed;
@property (nonatomic, assign) float score;

+ (RouteTrailData *)initModelWithTripCellData:(TripCellData *)tripDt;

@end
