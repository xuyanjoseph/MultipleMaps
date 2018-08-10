//
//  NetworkTools.m
//  168CarDVR
//
//  Created by jimmy on 2018/2/6.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "NetworkTools.h"
#import "AFNetworking.h"

@implementation NetworkTools
{
    AFHTTPSessionManager *_manager;
}
#pragma mark - 创建单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static NetworkTools *tools=nil;
    dispatch_once(&onceToken, ^{
        tools =[[NetworkTools alloc]init];
    });
    return tools;
}
//设置返回数据为2进制
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager=[AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        // 设置响应数据为JSON格式（[AFJSONResponseSerializer serializer]）或者二进制格式（ [AFHTTPResponseSerializer serializer]）
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 5;
    }
    return self;
}

- (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary * data,NSError *error))cb {
    [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        cb(dict, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        cb(nil, error);
    }];
}

@end
