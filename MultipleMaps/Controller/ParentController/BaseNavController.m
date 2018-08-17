//
//  BaseNavController.m
//  MultipleMaps
//
//  Created by dev on 2018/8/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "BaseNavController.h"
#import "routeTrailViewController.h"
#import "AMapRouteTrailViewController.h"
#import "Utils.h"

@interface BaseNavController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"BaseNavController");
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (!self) {
        return nil;
    }
    NSLog(@"初始化基础导航控制器");
    self.delegate = self;
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    
    Class baiduMapVcClass = [routeTrailViewController class];
    Class aliMapVcClass = [AMapRouteTrailViewController class];
    
    BOOL isBaiduMap = [viewController isKindOfClass:baiduMapVcClass];
    BOOL isAliMap = [viewController isKindOfClass:aliMapVcClass];
    
    if (isBaiduMap) {

        viewController.navigationItem.titleView = [Utils configNavBarTitle:@"百度地图"];
        
    } else if (isAliMap) {

        viewController.navigationItem.titleView = [Utils configNavBarTitle:@"高德地图"];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
