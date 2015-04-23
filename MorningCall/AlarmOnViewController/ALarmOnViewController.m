//
//  ALarmOnViewController.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "ALarmOnViewController.h"

//#import "UIViewController+LayoutExtension.h"

CGFloat yPositionAdjustment = 10.f;

@interface ALarmOnViewController ()

@end

@implementation ALarmOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeLabel.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)/4-yPositionAdjustment);
    
    _userIconBG.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*2/5, CGRectGetWidth([UIScreen mainScreen].bounds)*2/5);
    _userIconBG.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)/2);
    _userIconBG.clipsToBounds = YES;
    _userIconBG.layer.cornerRadius =_userIconBG.frame.size.width/2;
    
    _userIcon.frame = CGRectMake(0, 0, CGRectGetWidth(_userIconBG.frame)/2, CGRectGetHeight(_userIconBG.frame)/2);
    _userIcon.center = _userIconBG.center;
    _userIcon.clipsToBounds = YES;
    _userIcon.layer.cornerRadius =_userIcon.frame.size.width/2;
    _userIcon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    _userIcon.layer.borderWidth = 2.f;
    _userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _stopAlarmButton.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)*3/4+yPositionAdjustment);
    [_stopAlarmButton addTarget:self action:@selector(stopAlarm:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *memoCenterX = [NSLayoutConstraint constraintWithItem:_memoLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_timeLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    NSLayoutConstraint *memoCenterY = [NSLayoutConstraint constraintWithItem:_memoLabel
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_timeLabel
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:50];
    _memoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[memoCenterX,memoCenterY]];
}

- (void)stopAlarm:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
