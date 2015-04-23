//
//  SettingTableController.m
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingTableController.h"
#import "LayoutExtension.h"
#import "Brain.h"
@interface SettingTableController () <UINavigationControllerDelegate>

@end

@implementation SettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationController.delegate = self;
    self.navigationController.navigationBar.tintColor = self.mc_BackgroundGreen;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf:)];
    self.title = @"Setting";
    
    CALayer *l = _userIconButton.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:_userIconButton.bounds.size.width/2];
    [l setBorderWidth:2.f];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
    [_userIconButton setBackgroundImage:[UIImage imageNamed:@"user1.png"] forState:UIControlStateNormal];
    
    _userNameLabel.text = [Me alive].privateInfo.uniqueName;
    
//    [_backButton removeFromSuperview];
//    [_backButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ( viewController == [navigationController.childViewControllers firstObject]) {
//        [navigationController setNavigationBarHidden:YES animated:animated];
//    } else if ( [navigationController isNavigationBarHidden] ) {
//        [navigationController setNavigationBarHidden:NO animated:animated];
//    }
//}

#pragma - MARK
#pragma - Button Action
- (void)dismissSelf:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
