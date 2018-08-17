//
//  VideoLaunchView.m
//  MultipleMaps
//
//  Created by dev on 2018/8/16.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "VideoLaunchView.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface VideoLaunchView()

@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVPlayerLayer *avplayerLayer;

@property (nonatomic, strong) UIButton *skipBtn;

@end

@implementation VideoLaunchView

#pragma mark - View Life Cycles

- (instancetype)initWithVideoURL:(NSURL *)videoUrl andVolume:(float)volume andFrame:(CGRect)frame {
    self = [super init];
    if (!self) {
        self = [[VideoLaunchView alloc] init];
    }
    
    [self configLaunchVideoWithUrl:videoUrl andVolume:volume andFrame:frame];
    [self addSubview:self.skipBtn];
    
    return self;
}

- (void)configLaunchVideoWithUrl:(NSURL *)videoUrl andVolume:(float)volume andFrame:(CGRect)frame {
    
    self.frame = frame;
    
    AVPlayerItem *avplayerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.avplayer = [AVPlayer playerWithPlayerItem:avplayerItem];
    self.avplayer.volume = volume;
    self.avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    self.avplayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.avplayerLayer.frame = (CGRect){0, 0, frame.size.width, frame.size.height * 0.8};
    [self.layer addSublayer:self.avplayerLayer];
    
    [self startToPlay];
}

- (void)startToPlay {
    if (self.avplayer) {
        [self.avplayer play];
    }
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake((320-100)/2, 568*0.85, 100, 568 * 0.1);
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_skipBtn setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
        _skipBtn.backgroundColor = [UIColor redColor];
//        [_skipBtn setBackgroundImage:[UIImage imageNamed:@"btn-login-1"] forState:UIControlStateDisabled];
//        [_skipBtn setBackgroundImage:[UIImage imageNamed:@"btn-login-2"] forState:UIControlStateNormal];
//        [_skipBtn setBackgroundImage:[UIImage imageNamed:@"btn-login-3"] forState:UIControlStateHighlighted];
        
        [_skipBtn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

- (void)skip:(UIButton *)sender {
    
    if (self.avplayer) {
        [self.avplayer pause];
    }
    
    [self removeFromSuperview];
}

@end
