//
//  CustomCalloutView.m
//  Category_demo2D
//
//  Created by xiaoming han on 13-5-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>

#define kArrorHeight    10

@interface CustomCalloutView()

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *evtTime;

@end

@implementation CustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self addSubview:self.name];
    [self addSubview:self.evtTime];
    self.hidden = YES;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width, (self.bounds.size.height-10-10-5)/2)];
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = [UIColor blackColor];
    }
    return _name;
}

- (UILabel *)evtTime {
    if (!_evtTime) {
        _evtTime = [[UILabel alloc] initWithFrame:CGRectMake(10, self.name.frame.origin.y + self.name.bounds.size.height + 5, self.bounds.size.width, self.name.bounds.size.height)];
        _evtTime.backgroundColor = [UIColor clearColor];
        _evtTime.textColor = [UIColor blackColor];
    }
    return _evtTime;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)configLabel:(NSArray *)labContentArr {
    self.name.text = (NSString *)labContentArr.firstObject;
    self.evtTime.text = (NSString *)labContentArr.lastObject;
}

@end
