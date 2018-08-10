//
//  TripCellData.m
//  168CarDVR
//
//  Created by jimmy on 2018/3/21.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "TripCellData.h"

@implementation TripCellData

- (instancetype)init {
    self = [super init];
    if (!self) {
        self = [[TripCellData alloc] init];
    }
    self.trip_id = 1531122312;
    self.device_id = @"cc79cffce238";
    self.time = 2544;
    self.score = 95.1100006;
    self.mileage = 18065;
    self.tired_count = 0;
    self.harsh_acce_count = 0;
    self.harsh_dece_count = 0;
    self.harsh_turn_count = 1;
    self.overspeed_count = 0;
    self.has_raw_data = 1;
    self.start_time = 1531122312;
    self.end_time = 1531124856;
    self.avg_speed = 25.5;
    self.end_lat = 22.5583572;
    self.end_lon = 113.942047;
    self.end_location = @"广东省深圳市南山区朗山路13号";
    self.max_speed = 65.0999985;
    self.start_lat = 22.558754;
    self.start_lon = 113.937775;
    self.start_location = @"广东省深圳市南山区广志道2";
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"trip_id" : @"id"};
}

@end
