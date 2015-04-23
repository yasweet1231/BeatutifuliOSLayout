//
//  SettingAddEmailAddress.m
//  MorningCall
//
//  Created by Tian Tian on 2/25/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingAddEmailAddress.h"

@interface SettingAddEmailAddress ()

@end

@implementation SettingAddEmailAddress

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Email Address";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _okButton.layer.cornerRadius = _okButton.bounds.size.width/2;
    _okButton.clipsToBounds = YES;
    [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _processingView.hidden = YES;
}

- (void)okButtonPressed:(UIButton *)sender{
    _processingView.frame = CGRectMake(0, 0, _processingView.frame.size.width, _processingView.frame.size.height);
    [_activityIndic startAnimating];
    _processingView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end
