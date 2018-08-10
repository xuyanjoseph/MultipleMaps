//
//  RouteTrailData.m
//  168CarDVR
//
//  Created by dev on 2018/5/9.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "RouteTrailData.h"

@interface RouteTrailData()

@end

@implementation RouteTrailData

+ (RouteTrailData *)initModelWithTripCellData:(TripCellData *)tripDt {
    RouteTrailData *routeData = [[RouteTrailData alloc] init];
    routeData.device_id = (tripDt.device_id ?: nil);
    routeData.trip_id = (tripDt.trip_id ? @(tripDt.trip_id).stringValue : nil);
    routeData.start_time = (tripDt.start_time ? @(tripDt.start_time) : nil);
    routeData.mileage = (@(tripDt.mileage) != nil ? tripDt.mileage : 0);
    routeData.time = (@(tripDt.time) != nil ? tripDt.time : 0);
    routeData.avg_speed = (@(tripDt.avg_speed) != nil ? tripDt.avg_speed : 0);
    routeData.max_speed = (@(tripDt.max_speed) != nil ? tripDt.max_speed : 0);
    routeData.score = (@(tripDt.score) != nil ? tripDt.score : 0);
    routeData.harsh_acce_count = (@(tripDt.harsh_acce_count) != nil ? tripDt.harsh_acce_count : 0);
    routeData.harsh_dece_count = (@(tripDt.harsh_dece_count) != nil ? tripDt.harsh_dece_count : 0);
    routeData.harsh_turn_count = (@(tripDt.harsh_turn_count) != nil ? tripDt.harsh_turn_count : 0);
    return routeData;
}

@end
