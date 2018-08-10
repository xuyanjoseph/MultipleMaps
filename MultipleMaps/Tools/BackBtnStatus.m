//
//  BackBtnStatus.m
//  168CarDVR
//
//  Created by dev on 2018/5/14.
//  Copyright © 2018年 zblazy. All rights reserved.
//

#import "BackBtnStatus.h"

@implementation BackBtnStatus

+ (instancetype)shareInstance {
    static dispatch_once_t singleToken;
    static BackBtnStatus *btnStatus = nil;
    
    dispatch_once(&singleToken, ^{
        btnStatus = [[BackBtnStatus alloc] init];
        btnStatus.vcTitle = @"";
    });
    
    return btnStatus;
}

@end
