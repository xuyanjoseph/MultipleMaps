//
//  NetworkTools.h
//  168CarDVR
//
//  Created by jimmy on 2018/2/6.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkTools : NSObject
+ (instancetype)shareInstance;
- (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary * data,NSError *error))cb;
@end
