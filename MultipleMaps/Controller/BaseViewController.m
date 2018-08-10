//
//  BaseViewController.m
//  168CarDVR
//
//  Created by dev on 2018/5/22.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(void)checkPCX {
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    sManager.requestSerializer = [AFJSONRequestSerializer new];
    sManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [sManager.requestSerializer setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    //    NSString *url = [NSString stringWithFormat:@"http://cross.kcnzq.net:8099/CarRecorder/InsuranceManage/InsuranceSearchInfo?SearchType=0&SearchValue=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DVR_deviceID"]];
    //    NSLog(@"%@",url);
    //    [sManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    //                NSLog(@"收到数据:%@",dic);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //    }];
    NSMutableDictionary *para =[NSMutableDictionary dictionary];
    
    [para setObject:@0 forKey:@"SearchType"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"DVR_deviceID"]!=nil) {
        [para setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"DVR_deviceID"] forKey:@"SearchValue"];
    }
    //    NSLog(@"dvrid:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DVR_deviceID"]);
    [sManager POST:@"http://cross.kcnzq.net:8099/CarRecorder/InsuranceManage/InsuranceSearchInfo?" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收到数据:%@",dic);
        if (dic[@"Message"]!=nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PCXCX" object:@"noBinding"];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PCXCX" object:@"Binding"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误:%@",error);
    }];
}

@end
