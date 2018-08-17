//
//  routeTrailViewController.m
//  168CarDVR
//
//  Created by dev on 2018/5/4.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "routeTrailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "RouteAnnotation.h"
#import "DriveEventsView.h"
#import "XLCircleProgress.h"
#import "UIColor+HEX.h"
#import "Utils.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface routeTrailViewController ()<BMKMapViewDelegate>
{
    CLLocationCoordinate2D startCoor;
    CLLocationCoordinate2D endCoor;
}

@property (nonatomic, strong) NSMutableArray *locationArrayM;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *bmkLocationService;

@property (nonatomic, strong) RouteAnnotation *routeStartAnno;
@property (nonatomic, strong) RouteAnnotation *routeEndAnno;

@end

@implementation routeTrailViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBMLocationService];
    [self initMapView];
    [self initStartAndEndCoordinates];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"%s", __FUNCTION__);
   
    [self sendReqToGetRouteTrailWithMapType:@"baidu" andBlock:^(NSArray *hisQueryArr) {
        if (hisQueryArr && hisQueryArr.count > 0) {
            float total_lati = 0, total_long = 0, center_lati = 0, center_long = 0;
            
            NSUInteger hisQueryArrCnt = hisQueryArr.count;
            
            CLLocationCoordinate2D *locCoorArr = (CLLocationCoordinate2D *)malloc(hisQueryArrCnt * sizeof(CLLocationCoordinate2D));
            
            NSMutableArray *routeAnnoMArr = [[NSMutableArray alloc] initWithCapacity:0];
            //添加折线覆盖物
            for (NSUInteger i = 0; i < hisQueryArrCnt; i++) {
                NSDictionary *trailDic = (NSDictionary *)hisQueryArr[i];
                float curLati = ((NSNumber *)[trailDic objectForKey:@"latitude"]).floatValue;
                float curLong = ((NSNumber *)[trailDic objectForKey:@"longitude"]).floatValue;
                NSInteger evtType = ((NSNumber *)[trailDic objectForKey:@"type"]).integerValue;
                NSString *evtTime = ((NSString *)[trailDic objectForKey:@"time"]);
                NSLog(@"evtType:%ld", (long)evtType);
                
                total_long += curLong;
                total_lati += curLati;
                
                locCoorArr[i].latitude = curLati;
                locCoorArr[i].longitude = curLong;
                
                NSString *evtTitle = nil;
                NSInteger eventType = -1;
                
                if (0 == i) {
                    evtTitle = @"起点";
                    eventType = 0;
                    
                } else if ((hisQueryArrCnt - 1) == i) {
                    evtTitle = @"终点";
                    eventType = 1;
                    
                } else if (7 == evtType || 8 == evtType || 9 == evtType) {
                    evtTitle = (7 == evtType ? @"急加速": (8 == evtType ? @"急减速": @"急转弯"));
                    eventType = evtType;
                    
                }
                
                if (evtTitle && eventType != -1) {
                    CLLocationCoordinate2D evtCoor = CLLocationCoordinate2DMake(curLati, curLong);
                    RouteAnnotation *routeAnno = [self addEvtPointAnnoWithType:eventType andCoordinate:evtCoor title:evtTitle subTitle:evtTime];
                    [routeAnnoMArr addObject:routeAnno];
                }
                
            }
            
            center_lati = total_lati/(float)hisQueryArrCnt;
            center_long = total_long/(float)hisQueryArrCnt;
            NSLog(@"中心点纬度:%f, 中心点经度:%f", center_lati, center_long);
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(center_lati, center_long);
            BMKCoordinateSpan span = BMKCoordinateSpanMake(0.038325, 0.028045);
            BMKCoordinateRegion adjustRegion = [self.mapView regionThatFits:BMKCoordinateRegionMake(center, span)];
            [self.mapView setRegion:adjustRegion animated:YES];
            
            BMKPolyline *curPolyline = [BMKPolyline polylineWithCoordinates:locCoorArr count:hisQueryArrCnt];

            if (curPolyline) {
                [self.mapView addOverlay:curPolyline];
                
                if (routeAnnoMArr.count > 0) {
                    [self.mapView addAnnotations:routeAnnoMArr];
                }
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"无法获取行程轨迹";
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.bezelView.backgroundColor = [UIColor blackColor];
            hud.contentColor = [UIColor whiteColor];
            [hud hideAnimated:YES afterDelay:1.f];
        }
    }];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor colorWithHexString:@"#1e77ee"];
        polylineView.lineWidth = 2.5;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSLog(@"%s", __FUNCTION__);
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        RouteAnnotation *routeAnno = (RouteAnnotation *)annotation;
        BMKAnnotationView *bmkAnnoV = [routeAnno getRouteAnnotationView:mapView];
        bmkAnnoV.draggable = NO;
        return bmkAnnoV;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"//点击泡泡//");
    [mapView deselectAnnotation:view.annotation animated:NO];
}

#pragma mark - Init Methods

- (void)initBMLocationService {
    self.bmkLocationService = [[BMKLocationService alloc] init];
    self.bmkLocationService.distanceFilter = 10;
    self.bmkLocationService.desiredAccuracy = kCLLocationAccuracyBest;
    
}

- (void)initMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 10;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.rotateEnabled = NO;
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    [self.view addSubview:_mapView];
    self.subMapView = self.mapView;
}

- (void)initStartAndEndCoordinates {
    startCoor.latitude = 0;
    startCoor.longitude = 0;
    endCoor.latitude = 0;
    endCoor.longitude = 0;
}

#pragma mark - Helpers

- (RouteAnnotation *)addEvtPointAnnoWithType:(NSInteger)evtType andCoordinate:(CLLocationCoordinate2D)evtCoor title:(NSString *)title subTitle:(NSString *)subTitle {
    RouteAnnotation *evtAnno = [[RouteAnnotation alloc] init];
    evtAnno.type = evtType;
    evtAnno.coordinate = evtCoor;
    evtAnno.title = title;
    evtAnno.subtitle = subTitle;
    return evtAnno;
}

@end
