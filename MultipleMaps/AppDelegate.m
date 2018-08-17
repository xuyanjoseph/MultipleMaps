//
//  AppDelegate.m
//  MultiMap
//
//  Created by dev on 2018/7/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "VideoLaunchView.h"
#import "RootViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager *_mapManager;
}

@property (nonatomic, strong) VideoLaunchView *vidLaunchV;

@end

@implementation AppDelegate

+ (instancetype)sharedInstance {
    static AppDelegate *appDelegateObj;
    static dispatch_once_t appDelToken;
    dispatch_once(&appDelToken, ^{
        appDelegateObj = [[AppDelegate alloc] init];
    });
    
    return appDelegateObj;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
//        ViewController *rootVC = [[ViewController alloc] init];
//        UINavigationController *rootNavCtl = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *rootNavCtl = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNavCtl;
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:self.vidLaunchV];
    [self.window bringSubviewToFront:self.vidLaunchV];
    
    [self configBaiduMapKey];
    [self configAliMapKey];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    if (self.vidLaunchV) {
//        [self.vidLaunchV startToPlay];
//    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Baidu Map Config Methods

- (void)configBaiduMapKey {
    _mapManager = [[BMKMapManager alloc] init];
    BOOL setKeyResult = [_mapManager
                         start:@"3KMPKS8iTvjTPRpTzGLwGeTIZP26b5KV"
                         generalDelegate:nil];
    if (!setKeyResult) {
        NSString *reason = [NSString stringWithFormat:@"百度地图apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - AMap Config Methods

- (void)configAliMapKey {
    if (0 == [APIKey length]) {
        NSString *reason = [NSString stringWithFormat:@"阿里地图apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (VideoLaunchView *)vidLaunchV {
    if (!_vidLaunchV) {
        NSString *videoFilePath = [[NSBundle mainBundle] pathForResource:@"emoji_zone" ofType:@"mp4"];
        NSURL *videoUrl = [NSURL fileURLWithPath:videoFilePath];
        _vidLaunchV = [[VideoLaunchView alloc] initWithVideoURL:videoUrl andVolume:0.7 andFrame:[UIScreen mainScreen].bounds];
    }
    return _vidLaunchV;
}

@end
