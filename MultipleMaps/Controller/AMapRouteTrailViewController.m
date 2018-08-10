//
//  AMapRouteTrailViewController.m
//  168CarDVR
//
//  Created by dev on 2018/7/17.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "AMapRouteTrailViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
//#import "BackBtnStatus.h"
#import "DriveEventsView.h"
#import "XLCircleProgress.h"
#import "UIColor+HEX.h"
//#import "GeneralMethods.h"
#import "AFNetworking.h"
#import "MADriEvtAnnotation.h"
#import "CustomAnnotationView.h"
#import "MBProgressHUD.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static CGFloat annotationImgHt = 29;

@interface AMapRouteTrailViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *maMapView;

@property (nonatomic, strong) NSMutableArray *processedOverlays; //处理后的
@property (nonatomic, strong) NSOperation *queryOperation;

@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D evtCoordinate;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) CustomAnnotationView *curSelAnnoView;

@end

@implementation AMapRouteTrailViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.curSelAnnoView = nil;
    [self initMaMapView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self sendReqToGetRouteTrailWithMapType:@"amap" andBlock:^(NSArray *hisQueryArr) {
        if (hisQueryArr && hisQueryArr.count > 0) {
            
            NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *routeAnnoMArr = [[NSMutableArray alloc] initWithCapacity:0];
//            NSMutableArray *jsonMArr = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSUInteger hisQueryArrCnt = hisQueryArr.count;
            NSLog(@"纠偏前轨迹点个数 hisQueryArrCnt:%lu", hisQueryArrCnt);
            if (self.processedOverlays && self.processedOverlays.count > 0) {
                [self.processedOverlays removeAllObjects];
            }
            
            for (NSUInteger i = 0; i < hisQueryArrCnt; i++) {
                NSDictionary *trailDic = (NSDictionary *)hisQueryArr[i];
                if (i == 2) {
                    NSLog(@"trailDic:%@", trailDic);
                }
                CLLocationCoordinate2D amapCoor = CLLocationCoordinate2DMake([[trailDic objectForKey:@"latitude"] doubleValue], [[trailDic objectForKey:@"longitude"] doubleValue]);

                NSString *timeStr = (NSString *)[trailDic objectForKey:@"time"];
                NSInteger evtType = [[trailDic objectForKey:@"type"] integerValue];

                if (7 == evtType || 8 == evtType || 9 == evtType) {
                    self.evtCoordinate = amapCoor;
                    MADriEvtAnnotationType driEvtType = (7 == evtType ? MADriEvtAnnotationType_HarshAcce : (8 == evtType ? MADriEvtAnnotationType_HarshDece : MADriEvtAnnotationType_HarshTurn));

                    [routeAnnoMArr addObject:[self createAnnotationWithEvtType:driEvtType andEvtTime:timeStr]];
                }

                if (0 == i || (hisQueryArrCnt - 1) == i) {
                    if (i) {
                        self.endTime = timeStr;
                    } else {
                        self.startTime = timeStr;
                    }
                }
                
                MATraceLocation *loc = [[MATraceLocation alloc] init];
                loc.loc = amapCoor;
                loc.speed = [[trailDic objectForKey:@"speed"] doubleValue];
                loc.angle = [[trailDic objectForKey:@"direction"] doubleValue];
                loc.time = [[Utils getMilliTimStaNumFromTimeString:timeStr] doubleValue];
//                NSLog(@"lat: %.6f, lon: %.6f, speed:%.2f, bearing: %.2f, loctime:%.1f", loc.loc.latitude, loc.loc.longitude, loc.speed, loc.angle, loc.time);
                if (fabs(amapCoor.longitude - 0) < 0.0001 && fabs(amapCoor.latitude - 0) < 0.0001) {
                    continue;
                }
                
                [mArr addObject:loc];
            }
            
            MATraceManager *temp = [[MATraceManager alloc] init];
            
            __weak typeof(self) weakSelf = self;
            NSOperation *op = [temp queryProcessedTraceWith:mArr type:AMapCoordinateTypeAMap processingCallback:^(int index, NSArray<MATracePoint *> *points) {

                NSLog(@"还没画完 points count:%lu", (unsigned long)points.count);
                [weakSelf addSubTrace:points toMapView:weakSelf.maMapView];

            } finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
                NSUInteger tracePointCnt = points.count;
                NSLog(@"纠偏后的轨迹点个数 tracePointCnt:%lu", tracePointCnt);
                
                weakSelf.queryOperation = nil;
                [weakSelf addFullTrace:points toMapView:weakSelf.maMapView];

                MATracePoint *startPoint = (MATracePoint *)[points objectAtIndex:0];
                MATracePoint *endPoint = (MATracePoint *)[points objectAtIndex:(tracePointCnt-1)];

                self.startCoordinate = CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude);
                self.endCoordinate = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);

                NSMutableArray *evtAnnoMArr = [[NSMutableArray alloc] initWithCapacity:0];
                [evtAnnoMArr addObject:[self createAnnotationWithEvtType:MADriEvtAnnotationType_Start andEvtTime:self.startTime]];
                [evtAnnoMArr addObject:[self createAnnotationWithEvtType:MADriEvtAnnotationType_End andEvtTime:self.endTime]];

                NSUInteger routeAnnoMArrCnt = routeAnnoMArr.count;
                for (NSUInteger i = 0; i < routeAnnoMArrCnt; i++) {
                    CLLocationDistance ptDistance = 0;
                    NSInteger targetTracePtIndex = -1;

                    MADriEvtAnnotation *oldAnno = (MADriEvtAnnotation *)[routeAnnoMArr objectAtIndex:i];
                    MAMapPoint oldMapPt = MAMapPointForCoordinate(oldAnno.coordinate);

                    for (NSUInteger j = 0; j < tracePointCnt; j++) {
                        MATracePoint *newPoint = (MATracePoint *)[points objectAtIndex:j];
                        CLLocationCoordinate2D newLoc = CLLocationCoordinate2DMake(newPoint.latitude, newPoint.longitude);
                        MAMapPoint newMapPt = MAMapPointForCoordinate(newLoc);

                        CLLocationDistance curDistance = MAMetersBetweenMapPoints(oldMapPt, newMapPt);
                        if (j == 0) {
                            ptDistance = curDistance;
                            targetTracePtIndex = 0;
                        } else {
                            if (curDistance < ptDistance) {
                                ptDistance = curDistance;
                                targetTracePtIndex = j;
                            }
                        }
                    }

                    if (targetTracePtIndex >= 0) {
                        MATracePoint *targetPoint = (MATracePoint *)[points objectAtIndex:targetTracePtIndex];
                        self.evtCoordinate = CLLocationCoordinate2DMake(targetPoint.latitude, targetPoint.longitude);

                        [evtAnnoMArr addObject:[self createAnnotationWithEvtType:oldAnno.driEvtType andEvtTime:oldAnno.evtTime]];
                    }
                }

                [self addAnnotationOnMap:evtAnnoMArr];

            } failedCallback:^(int errorCode, NSString *errorDesc) {

                NSLog(@"Error: %@", errorDesc);
                weakSelf.queryOperation = nil;
            }];
            
            self.queryOperation = op;
            
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _maMapView.delegate = nil;
}

- (void)dealloc {
    
    if (_maMapView) {
        [_maMapView removeFromSuperview];
        _maMapView = nil;
    }
}

#pragma mark - Init Methods

- (void)initMaMapView {
    self.processedOverlays = [NSMutableArray array];
    
    _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, 320, 568-64)];
    _maMapView.mapType = MAMapTypeStandard;
    _maMapView.showsUserLocation = YES;
    _maMapView.userTrackingMode = MAUserTrackingModeNone;
    _maMapView.delegate = self;
    [self.view addSubview:_maMapView];
    self.subMapView = self.maMapView;
}

#pragma mark - Helpers

- (void)addFullTrace:(NSArray<MATracePoint*> *)tracePoints toMapView:(MAMapView *)mapView{
    MAMultiPolyline *polyline = [self makePolyLineWith:tracePoints];
    if(!polyline) {
        return;
    }
    
    if(mapView == self.maMapView) {
        [mapView removeOverlays:self.processedOverlays];
        [self.processedOverlays removeAllObjects];
    } else {
        //        [mapView removeOverlays:self.origOverlays];
        //        [self.origOverlays removeAllObjects];
    }
    
    [mapView setVisibleMapRect:MAMapRectInset(polyline.boundingMapRect, -1000, -1000)];
    
    if(mapView == self.maMapView) {
        [self.processedOverlays addObject:polyline];
        [mapView addOverlays:self.processedOverlays];
    } else {
        //        [self.origOverlays addObject:polyline];
        //        [mapView addOverlays:self.origOverlays];
    }
}

- (void)addSubTrace:(NSArray<MATracePoint*> *)tracePoints toMapView:(MAMapView *)mapView {
    MAMultiPolyline *polyline = [self makePolyLineWith:tracePoints];
    if(!polyline) {
        return;
    }
    
    MAMapRect visibleRect = [mapView visibleMapRect];
    if(!MAMapRectContainsRect(visibleRect, polyline.boundingMapRect)) {
        MAMapRect newRect = MAMapRectUnion(visibleRect, polyline.boundingMapRect);
        [mapView setVisibleMapRect:newRect];
    }
    
    if(mapView == self.maMapView) {
        [self.processedOverlays addObject:polyline];
    } else {
        //        [self.origOverlays addObject:polyline];
    }
    
    [mapView addOverlay:polyline];
//    [mapView addOverlays:self.processedOverlays];
}

- (MAMultiPolyline *)makePolyLineWith:(NSArray<MATracePoint*> *)tracePoints {
    if(tracePoints.count == 0) {
        return nil;
    }
    
    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * tracePoints.count);
    if(!pCoords) {
        return nil;
    }
    
    for(int i = 0; i < tracePoints.count; ++i) {
        MATracePoint *p = [tracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
        pCur->latitude = p.latitude;
        pCur->longitude = p.longitude;
    }
    
    MAMultiPolyline *polyline = [MAMultiPolyline polylineWithCoordinates:pCoords count:tracePoints.count drawStyleIndexes:@[@10, @60]];
    
    if(pCoords) {
        free(pCoords);
    }
    
    return polyline;
}

- (void)addAnnotationOnMap:(NSArray *)annotationArr {
    for (MADriEvtAnnotation *driEvtAnno in annotationArr) {
        [self.maMapView addAnnotation:driEvtAnno];
    }
}

- (MADriEvtAnnotation *)createAnnotationWithEvtType:(MADriEvtAnnotationType)driEvtType andEvtTime:(NSString *)evtTime {
    MADriEvtAnnotation *annotation = [[MADriEvtAnnotation alloc] init];
    annotation.driEvtType = driEvtType;
    annotation.coordinate = (MADriEvtAnnotationType_Start == driEvtType
                                 ? self.startCoordinate
                                 : (MADriEvtAnnotationType_End == driEvtType
                                    ? self.endCoordinate
                                    : self.evtCoordinate
                                   )
                            );
    annotation.evtTime = evtTime;
    return annotation;
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    NSLog(@"renderers :%@", renderers);
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        if (mapView == self.maMapView) {
            polylineView.lineWidth   = 5.0f;
//            polylineView.strokeImage = [UIImage imageNamed:@"custtexture"];
            polylineView.strokeColor = [UIColor colorWithHexString:@"#1e77ee"];
        }
        return polylineView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView  viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MADriEvtAnnotation class]]) {
        static NSString *annotationIdentifier = @"AnnotationFlag";
        
        CustomAnnotationView *routeAnnotationView = (CustomAnnotationView *)[self.maMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (routeAnnotationView == nil) {
            routeAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            routeAnnotationView.canShowCallout = NO;
        }

        NSArray *routeAnnoImgArr = @[@"icon_location_Starting",
                                     @"icon_location_end",
                                     @"icon_location_SharpAcceleration",
                                     @"icon_location_SharpDeceleration",
                                     @"icon_location_SharpCornering"
                                    ];
        MADriEvtAnnotationType evtType = ((MADriEvtAnnotation *)annotation).driEvtType;
        routeAnnotationView.image = [UIImage imageNamed:[routeAnnoImgArr objectAtIndex:evtType]];
        routeAnnotationView.centerOffset = CGPointMake(0, -annotationImgHt/2);
        return routeAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewTapped:(MAAnnotationView *)view {
    NSLog(@"点击 AnnotationView");
    
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        
        if (self.curSelAnnoView) {
            if (self.curSelAnnoView != cusView) {
                self.curSelAnnoView.calloutView.hidden = YES;
                [self.curSelAnnoView setSelected:NO animated:YES];
                self.curSelAnnoView = cusView;
            }
        } else {
            self.curSelAnnoView = cusView;
        }
        
        cusView.calloutView.hidden = (cusView.isSelected ? NO : YES);
        [cusView setSelected:!cusView.isSelected animated:YES];
        
        if ([cusView.annotation isKindOfClass:[MADriEvtAnnotation class]]) {
            MADriEvtAnnotation *evtAnnotation = (MADriEvtAnnotation *)cusView.annotation;
            NSArray *evtNameArr = @[@"起点", @"终点", @"急加速", @"急减速", @"急转弯"];
            NSString *evtName = [evtNameArr objectAtIndex:(NSUInteger)evtAnnotation.driEvtType];
            [cusView.calloutView configLabel:@[evtName, evtAnnotation.evtTime]];
        }
    }
}

@end
