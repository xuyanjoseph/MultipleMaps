//
//  BaseMapViewController.m
//  168CarDVR
//
//  Created by dev on 2018/7/19.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "BaseMapViewController.h"
#import "AppDelegate.h"
#import "UIColor+HEX.h"
#import "BackBtnStatus.h"
#import "GeneralMethods.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "routeTrailViewController.h"
#import "AMapRouteTrailViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, ZoomBtnType) {
    ZoomBtnType_ZoomOut = 0,
    ZoomBtnType_ZoomIn
};

@interface BaseMapViewController ()

@property (nonatomic, assign) ZoomBtnType zoomBtnType;

@property (nonatomic, strong) DriveEventsView *driEvtView;
@property (nonatomic, strong) DriveEventsView *driInfoView;

@property (nonatomic, strong) XLCircleProgress *cirProg;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, strong) UIButton *zoomOutBtn;
@property (nonatomic, strong) UIButton *zoomInBtn;

@property (nonatomic, strong) UIViewController *referMapVC;

@end

@implementation BaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = GETLOCSTR(@"RouteTrailVC_navItemTitleKey");
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [BackBtnStatus shareInstance].vcTitle = @"routeTrailViewController";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self configSubViews];
    [self refreshUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark - Helpers

- (void)configSubViews {
    
    for (UIViewController *subVC in self.parentViewController.childViewControllers) {
        BOOL isAliMapType = [subVC isKindOfClass:[AMapRouteTrailViewController class]];
        BOOL isBaiduMapType = [subVC isKindOfClass:[routeTrailViewController class]];
        
        if (isAliMapType || isBaiduMapType) {
            self.referMapVC = subVC;
            break;
        }
    }
    
    [self.referMapVC.view addSubview:self.topView];
    [self.topView addSubview:self.cirProg];
    [self.topView addSubview:self.middleView];
    [self.topView addSubview:self.driEvtView];
    [self.referMapVC.view bringSubviewToFront:self.topView];
    [self.referMapVC.view addSubview:self.driInfoView];
    [self.referMapVC.view bringSubviewToFront:self.driInfoView];
    
    [self.referMapVC.view addSubview:self.zoomInBtn];
    [self.referMapVC.view bringSubviewToFront:self.zoomInBtn];
    [self.referMapVC.view addSubview:self.zoomOutBtn];
    [self.referMapVC.view bringSubviewToFront:self.zoomOutBtn];
}

- (void)refreshUI {
    self.cirProg.progress = self.routeTrailDt.score;
    [self.driEvtView refreshEventView:self.routeTrailDt];
    [self.driInfoView refreshInfoView:self.routeTrailDt];
}

#pragma mark - Setters And Getters

- (DriveEventsView *)driEvtView {
    if (!_driEvtView) {
        CGFloat driEvtOriX = self.middleView.frame.origin.x + self.middleView.bounds.size.width + 5;
        CGRect driEvtRect = (CGRect){driEvtOriX, 0, self.topView.bounds.size.width - driEvtOriX - 10, self.topView.bounds.size.height};
        
        NSArray *evtArr = @[@"超速", @"疲劳驾驶", @"急转弯", @"急加速", @"急刹车"];
        NSDictionary *driEvtDic = @{@"events": evtArr,
                                    @"image": [NSNumber numberWithBool:YES],
                                    @"badge": [NSNumber numberWithBool:YES]};
        
        _driEvtView = [[DriveEventsView alloc] initWithFrame:driEvtRect srcArr:driEvtDic];
        
    }
    return _driEvtView;
}

- (DriveEventsView *)driInfoView {
    if (!_driInfoView) {
        CGFloat driEvtHt = 44;
        CGRect driEvtRect = (CGRect){0, SCREEN_HEIGHT - driEvtHt, SCREEN_WIDTH, driEvtHt};
        
        NSArray *evtArr = @[@"里程", @"时长", @"平均速度", @"最高速度"];
        NSArray *evtInfoArr = @[];
        
        NSDictionary *driEvtDic = @{@"events": evtArr,
                                    @"eventInfo": evtInfoArr,
                                    @"image": [NSNumber numberWithBool:NO],
                                    @"badge": [NSNumber numberWithBool:NO]};
        
        _driInfoView = [[DriveEventsView alloc] initWithFrame:driEvtRect srcArr:driEvtDic];
        
    }
    return _driInfoView;
}

- (XLCircleProgress *)cirProg {
    float circleHt = ceilf(self.topView.bounds.size.height - 2*leftSidePadding);
    
    if (!_cirProg) {
        _cirProg = [[XLCircleProgress alloc] initWithFrame:CGRectMake(leftSidePadding, leftSidePadding, circleHt, circleHt)];
        _cirProg.superVClassType = SuperViewClassType_RouteHeaderView;
    }
    return _cirProg;
}

- (UIView *)topView {
    if (!_topView) {
        CGFloat topVHt = [GeneralMethods configureMapTopVHt];
        
        _topView = [[UIView alloc] initWithFrame:(CGRect){0, 64, SCREEN_WIDTH, topVHt}];
        _topView.backgroundColor = [UIColor whiteColor];
        UIView *bottomLineV = [[UIView alloc] initWithFrame:(CGRect){0, _topView.bounds.size.height - 1, SCREEN_WIDTH, 1}];
        bottomLineV.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    return _topView;
}

- (UIView *)middleView {
    if (!_middleView) {
        CGFloat middleOriX = 2*leftSidePadding + self.cirProg.bounds.size.width;
        CGFloat middleOriY = 5;
        CGFloat middleHt = self.topView.bounds.size.height - 2*middleOriY;
        
        _middleView = [[UIView alloc] initWithFrame:(CGRect){middleOriX, middleOriY, 1, middleHt}];
        _middleView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        
    }
    return _middleView;
}

- (UIButton *)zoomOutBtn {
    if (!_zoomOutBtn) {
        self.zoomBtnType = ZoomBtnType_ZoomOut;
        CGRect zoomOutRect = CGRectMake(self.zoomInBtn.frame.origin.x, self.zoomInBtn.frame.origin.y - 12 - zoomBtnSize, zoomBtnSize, zoomBtnSize);
        _zoomOutBtn = [self configZoomBtn:zoomOutRect];
    }
    return _zoomOutBtn;
}

- (UIButton *)zoomInBtn {
    if (!_zoomInBtn) {
        self.zoomBtnType = ZoomBtnType_ZoomIn;
        
        CGRect zoomInRect = CGRectMake(SCREEN_WIDTH - 20 - zoomBtnSize, self.driInfoView.frame.origin.y - 15 - zoomBtnSize, zoomBtnSize, zoomBtnSize);
        _zoomInBtn = [self configZoomBtn:zoomInRect];
    }
    return _zoomInBtn;
}

- (UIButton *)configZoomBtn:(CGRect)rect {
    UIButton *zoomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    zoomBtn.tag = (ZoomBtnType_ZoomOut == self.zoomBtnType ? 1 : 2);
    zoomBtn.frame = rect;
    
    NSString *normalImgName = (ZoomBtnType_ZoomOut == self.zoomBtnType ? @"icon_Blow-Up" : @"icon_narrow");
    NSString *selectImgName = (ZoomBtnType_ZoomOut == self.zoomBtnType ? @"icon_Blow-Up_click" : @"icon_narrow_click");
    
    [zoomBtn setBackgroundImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    [zoomBtn setBackgroundImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];
    [zoomBtn addTarget:self action:@selector(zoomMapV:) forControlEvents:UIControlEventTouchUpInside];
    return zoomBtn;
}

#pragma mark - Action Response Methods
- (void)zoomMapV:(UIButton *)sender {
    NSLog(@"点击放大或者缩小按钮了");
    NSString *actionName = (1 == sender.tag ? @"Out" : @"In");

    BOOL ifZoomOut = [actionName isEqualToString:@"Out"];

    if (self.subMapView) {
        BOOL judgeZoomLevel = NO;
        BOOL isBaiduMap = NO;
        BMKMapView *baiduMapView = nil;
        MAMapView *maMapView = nil;
        
        if ([self.subMapView isKindOfClass:[BMKMapView class]]) {
            baiduMapView = (BMKMapView *)self.subMapView;
             judgeZoomLevel = (ifZoomOut?(baiduMapView.zoomLevel >= allowedMaxZoomLevel):(baiduMapView.zoomLevel <= allowedMinZoomLevel));
            isBaiduMap = YES;
            
        } else if ([self.subMapView isKindOfClass:[MAMapView class]]) {
            maMapView = (MAMapView *)self.subMapView;
            judgeZoomLevel = (ifZoomOut?(maMapView.zoomLevel >= AMap_allowedMaxZoomLevel):(maMapView.zoomLevel <= AMap_allowedMinZoomLevel));
        }
        

        if (judgeZoomLevel) {
            [GeneralMethods configHUD:self.referMapVC.view labText:(ifZoomOut ? @"不能再放大哦!" : @"不能再缩小哦!") delay:1];
        } else {
            if (isBaiduMap) {
                (ifZoomOut ? [baiduMapView zoomIn] : [baiduMapView zoomOut]);
            } else {
                CGFloat newZoomLevel = (ifZoomOut ? (maMapView.zoomLevel + 1) : (maMapView.zoomLevel - 1));
                [maMapView setZoomLevel:newZoomLevel animated:YES];
            }
            
        }
    }
}

#pragma mark - Network Request

- (void)sendReqToGetRouteTrailWithMapType:(NSString *)mapType andBlock:(void (^)(NSArray *))overBlock {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userToken = (NSString *)[userDef objectForKey:locTokenKey];
    NSString *userId = (NSString *)[userDef objectForKey:locIdKey];
    
    if (userId == nil || userToken == nil || !self.routeTrailDt.device_id || !self.routeTrailDt.trip_id || !self.routeTrailDt.start_time) {
        NSLog(@"行程轨迹查询请求的参数不全");
        return;
    }
    
    AFHTTPSessionManager *hisQueryReqManager = [AFHTTPSessionManager manager];
    hisQueryReqManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [hisQueryReqManager.requestSerializer setValue:httpContTypeVal forHTTPHeaderField:httpContTypeKey];
    
    NSMutableDictionary *hisQueryParas = [NSMutableDictionary dictionaryWithCapacity:0];
    [hisQueryParas setObject:userId forKey:@"user_id"];
    [hisQueryParas setObject:userToken forKey:@"token"];
    [hisQueryParas setObject:self.routeTrailDt.device_id forKey:@"device_id"];
    [hisQueryParas setObject:self.routeTrailDt.trip_id forKey:@"trip_id"];
    [hisQueryParas setObject:self.routeTrailDt.start_time forKey:@"start_time"];
    [hisQueryParas setObject:mapType forKey:@"map_type"];
    
    NSString *hisQueryReqIndex = @"/trip/his/query";
    NSString *hisQueryReqAdd = [NSString stringWithFormat:@"%@%@", SERVER_STROKE, hisQueryReqIndex];
    NSLog(@"行程轨迹查询接口完整地址:%@, 完整参数:%@", hisQueryReqAdd, hisQueryParas);
    
    [hisQueryReqManager POST:hisQueryReqAdd parameters:hisQueryParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!responseObject) {
            NSLog(@"行程轨迹查询失败了 responseObject is nil");
            if (overBlock) {
                overBlock(nil);
            }
        } else {
            
            NSArray *hisQueArr = [[NSArray alloc] init];
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSError *dayQueError = nil;
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&dayQueError];
                
                if (dayQueError) {
                    NSLog(@"行程轨迹查询返回结果解析失败了, 错误信息dayQueError:%@",dayQueError);
                    hisQueArr = nil;
                } else {
                    
                    if (0 == [[responseDic objectForKey:@"code"] intValue] && [[responseDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        
                        hisQueArr = (NSArray *)[responseDic objectForKey:@"data"];
                        
                    } else {
                        hisQueArr = nil;
                    }
                    
                }
            }
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (0 == [[responseObject objectForKey:@"code"] intValue]) {
                    
                    hisQueArr = (NSArray *)[((NSDictionary *)[responseObject objectForKey:@"data"]) objectForKey:@"his_list"];
                    
                } else {
                    hisQueArr = nil;
                }
            }
            if (overBlock) {
                overBlock(hisQueArr);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"行程轨迹查询失败了");
        if (error != nil) {
            NSLog(@"行程轨迹查询失败了, 错误信息 error:%@", error);
        }
        
        if (overBlock) {
            overBlock(nil);
        }
    }];
}

@end
