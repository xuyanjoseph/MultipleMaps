//
//  Utils.h
//  168CarDVR
//
//  Created by zblazy on 16/3/1.
//  Copyright © 2016年 zblazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject
//获得某个范围内的屏幕图像
+ (UIImage *)getImageFromView:(UIView *)view atFrame:(CGRect)rect;
+ (UIImage *)getImageFromSandbox:(NSString *)name;
+ (BOOL)writeImage:(UIImage *)image ToFile:(NSString *)fileName;

//获取指定目录的文件格式的所有文件集合
+ (NSArray *)getFileFor:(NSString *)fileFormat FromPathName:(NSString *)pathName;


+ (NSString *)getLocalTime;
+ (NSString *)getTimeStringFromTimestamp:(NSString *)timestamp;
//时间20160316142145转时间戳1458109305
+ (NSString *)getTimestampFromTimeString:(NSString *)timeStr;
+ (UIColor *) hexStringToColor:(NSString *)stringToConvert;
//时间20160316142145转毫秒时间戳1458109305000
+ (NSString *)getMilliSecsTimestampFromTimeString:(NSString *)timeStr;
//标准时间格式2016-03-16 14:21:45转毫秒时间戳1458109305000以NSNumber形式返回
+ (NSNumber *)getMilliTimStaNumFromTimeString:(NSString *)timeStr;

+ (UILabel *)configNavBarTitle:(NSString *)title;

@end
