//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@end

@implementation CustomAnnotationView

@synthesize calloutView;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        
        self.backgroundColor = [UIColor clearColor]; //[UIColor grayColor];
        
                if (self.calloutView == nil)
                {
                    /* Construct custom callout. */
//                    NSLog(@"弹出框偏移量 x:%f, y:%f", self.calloutOffset.x, self.calloutOffset.y);
                    self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
//                    self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                          -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                    self.calloutView.center = CGPointMake(10,
                                                          -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        
                }
        
                [self addSubview:self.calloutView];
        
    }
    
    return self;
}

@end
