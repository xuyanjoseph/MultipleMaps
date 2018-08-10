//
//  Utils.m
//  168CarDVR
//
//  Created by zblazy on 16/3/1.
//  Copyright © 2016年 zblazy. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (UIImage *)getImageFromView:(UIView *)view atFrame:(CGRect)rect {
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}

+ (UIImage *)getImageFromSandbox:(NSString *)name {
    NSError* err = [[NSError alloc] init];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@/DVMedias",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSAllDomainsMask, YES) objectAtIndex:0]],name]);
    
    NSData* data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/DVMedias/%@",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSAllDomainsMask, YES) objectAtIndex:0],name]
                                                  options:NSDataReadingMapped
                                                    error:&err];
    UIImage* img = nil;
    if(data != nil)
    {
        img = [[UIImage alloc] initWithData:data];
        
    }
    else
    {
        NSLog(@"getImageFileWithName error code : %@",[err description]);
    }
    return img;
}

+(NSArray *)getFileFor:(NSString *)fileFormat FromPathName:(NSString *)pathName {
    
    NSArray *fileArr = [[NSArray alloc] init];
    NSMutableArray *fileMutArr = [[NSMutableArray alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES) objectAtIndex:0];
    path = [path stringByAppendingFormat:@"/%@",pathName];
    
    NSError *error = [[NSError alloc] init];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        
        fileArr = [manager subpathsOfDirectoryAtPath:path error:&error];
    }
    
    if (fileArr.count > 0) {
        
        for (int i = 0; i < fileArr.count; i ++) {
            
            if ([fileArr[i] hasSuffix:[NSString stringWithFormat:@".%@",fileFormat]]) {
                
                [fileMutArr addObject:fileArr[i]];
            }
        }
    }
    
    return [fileMutArr copy];
    
}

+ (BOOL)writeImage:(UIImage *)image ToFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",fileName]];
    return [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
}

+ (NSString *)getLocalTime {
    NSDate* date=[NSDate date];
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSTimeZone* zone=[NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:zone];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getTimeStringFromTimestamp:(NSString *)timestamp {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:date];
}

//时间20160316142145转时间戳1458109305
+ (NSString *)getTimestampFromTimeString:(NSString *)timeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    return [NSString stringWithFormat:@"%d",(int)[[dateFormatter dateFromString:timeStr] timeIntervalSince1970]
            ];
}

+ (NSString *)getMilliSecsTimestampFromTimeString:(NSString *)timeStr {
    
    NSString *secTimeStr = [Utils getTimestampFromTimeString:timeStr];
    NSMutableString *mSecTimeStr = [[NSMutableString alloc] initWithString:secTimeStr];
    [mSecTimeStr appendString:@"000"];
    return mSecTimeStr;
    
}

+ (NSNumber *)getMilliTimStaNumFromTimeString:(NSString *)timeStr {
    NSMutableString *mTimeStr = [[NSMutableString alloc] initWithString:timeStr];
    [mTimeStr replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mTimeStr.length)];
    [mTimeStr replaceOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mTimeStr.length)];
    [mTimeStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mTimeStr.length)];
    
    NSNumberFormatter *numformat = [[NSNumberFormatter alloc] init];
    numformat.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *timeNum = [numformat numberFromString:[Utils getMilliSecsTimestampFromTimeString:mTimeStr]];
    return timeNum;
}

+ (UIColor *) hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
