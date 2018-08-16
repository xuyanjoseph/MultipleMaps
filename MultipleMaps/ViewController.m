//
//  ViewController.m
//  MultiMap
//
//  Created by dev on 2018/7/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ViewController.h"
#import "routeTrailViewController.h"
#import "AMapRouteTrailViewController.h"
#import "NetworkTools.h"
#import "DeviceTools.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *baiduBtn;
@property (nonatomic, strong) UIButton *aliBtn;

@property (nonatomic, strong) TripCellData *curTripData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"根视图控制器");
    
    [self configData];
    [self configSubViews];
}

#pragma mark - Setters And Getters

- (UIButton *)baiduBtn {
    if (!_baiduBtn) {
        _baiduBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 60)];
        _baiduBtn.tag = 1;
        [_baiduBtn setTitle:@"百度地图" forState:UIControlStateNormal];
        _baiduBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_baiduBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _baiduBtn.backgroundColor = [UIColor redColor];
        [_baiduBtn addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baiduBtn;
}

- (UIButton *)aliBtn {
    if (!_aliBtn) {
        _aliBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 100, 60)];
        _aliBtn.tag = 2;
        [_aliBtn setTitle:@"高德地图" forState:UIControlStateNormal];
        _aliBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_aliBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _aliBtn.backgroundColor = [UIColor blueColor];
        [_aliBtn addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliBtn;
}

#pragma mark - UI Layout

- (void)configSubViews {
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.baiduBtn];
    [self.view addSubview:self.aliBtn];
}

#pragma mark - Initialize Data

- (void)configData {
    
    self.curTripData = [[TripCellData alloc] init];
    [self fetchLocalKey];
    
}

#pragma mark - Network Request

- (void)fetchLocalKey {
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",SERVER_AUTH,@"/user/login"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[DeviceTools getPhoneParams]];
    params[@"phone_number"] = @"15899878931";
    params[@"captcha"] = @"111111";
    params[@"app_version"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    params[@"app_channel_id"] = @"chainway";
    [[NetworkTools shareInstance] postRequestWithUrl:reqUrl params:params result:^(NSDictionary *data, NSError *error) {
        if (data) {
            NSInteger backCode = [data[@"code"] integerValue];
            if (backCode == 0) {
                NSDictionary *backData = data[@"data"];
                // 保存数据在本地
                
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"id"] forKey:locIdKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"token"] forKey:locTokenKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"phone_number"] forKey:locPhoneKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"car_plate_number"] forKey:locCarPlaKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"car_vin"] forKey:locCarVinKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"time_zone"] forKey:locTimeZoneKey];
                [[NSUserDefaults standardUserDefaults] setObject:backData[@"type"] forKey:locTypeKey];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"%@%@", backData[@"id"], firmwareSuffix]];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                
            }else {
//                [loadingHud hideAnimated:NO];
//                _noticeLabel.text = data[@"message"];
//                _noticeView.hidden = NO;
//                // 200：手机号错误
//                // 202: 验证码发送太频繁
//                // 203: 验证码错误
//                // 206: 验证码已过期
//                // 207: 手机号未注册
//                if (backCode == 200 || backCode == 207) {
//                    _phoneTextField.layer.borderColor = [UIColor redColor].CGColor;
//                }else if (backCode == 203 || backCode == 206) {
//                    _codeTextField.layer.borderColor = [UIColor redColor].CGColor;
//                }else {
//                    _noticeView.hidden = YES;
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.label.text = data[@"message"];
//                    [hud hideAnimated:NO afterDelay:1];
//                }
            }
        }else {
//            [loadingHud hideAnimated:NO];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"网络请求错误";
            [hud hideAnimated:NO afterDelay:1];
        }
    }];
}

#pragma mark - Events Responds Methods

- (void)showMap:(UIButton *)sender {
    NSInteger btnTag = sender.tag;
    switch (btnTag) {
        case 1:
        {
            //百度地图
            routeTrailViewController *routeTrailVC = [[routeTrailViewController alloc] init];
            routeTrailVC.routeTrailDt = [RouteTrailData initModelWithTripCellData:self.curTripData];
            [self.navigationController pushViewController:routeTrailVC animated:YES];
        }
            break;
        case 2:
        {
            //高德地图
            AMapRouteTrailViewController *amapRouteTrailVC = [[AMapRouteTrailViewController alloc] init];
            amapRouteTrailVC.routeTrailDt = [RouteTrailData initModelWithTripCellData:self.curTripData];
            [self.navigationController pushViewController:amapRouteTrailVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
