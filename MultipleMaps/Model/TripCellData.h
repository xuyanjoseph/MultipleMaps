//
//  TripCellData.h
//  168CarDVR
//
//  Created by jimmy on 2018/3/21.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripCellData : NSObject
@property (nonatomic, assign) NSInteger trip_id;
@property (nonatomic, strong) NSString *device_id;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) NSInteger mileage;
@property (nonatomic, assign) NSInteger tired_count;
@property (nonatomic, assign) NSInteger harsh_acce_count;
@property (nonatomic, assign) NSInteger harsh_dece_count;
@property (nonatomic, assign) NSInteger harsh_turn_count;
@property (nonatomic, assign) NSInteger overspeed_count;
@property (nonatomic, assign) NSInteger has_raw_data;
@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, assign) float avg_speed;
@property (nonatomic, assign) float end_lat;
@property (nonatomic, assign) float end_lon;
@property (nonatomic, strong) NSString *end_location;
@property (nonatomic, assign) float max_speed;
@property (nonatomic, assign) float start_lat;
@property (nonatomic, assign) float start_lon;
@property (nonatomic, strong) NSString *start_location;
@end
