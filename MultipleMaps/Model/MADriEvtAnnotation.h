//
//  MADriEvtAnnotation.h
//  168CarDVR
//
//  Created by dev on 2018/7/18.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

typedef NS_ENUM(NSInteger, MADriEvtAnnotationType) {
    
    MADriEvtAnnotationType_Start = 0,
    MADriEvtAnnotationType_End,
    MADriEvtAnnotationType_HarshAcce,
    MADriEvtAnnotationType_HarshDece,
    MADriEvtAnnotationType_HarshTurn
};

@interface MADriEvtAnnotation : MAPointAnnotation

@property (nonatomic, assign) MADriEvtAnnotationType driEvtType;
@property (nonatomic, strong) NSString *evtTime;

@end
