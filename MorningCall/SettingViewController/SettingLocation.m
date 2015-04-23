//
//  SettingLocation.m
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingLocation.h"
#import "LayoutExtension.h"

#import "Brain.h"

@interface SettingLocation () <UIAlertViewDelegate>
//@property (nonatomic, strong) LocationHandler           *lctHandler;
@property (nonatomic, strong) UIActivityIndicatorView   *activityIndic;
@end

@implementation SettingLocation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Location";
    
    [self adjustCellLayout];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(regetLocation:)];
    
    _locationLabel.text = [Me alive].privateInfo.city;
    
    [self regetLocation:nil];
}

#pragma - Buttons
- (void)regetLocation:(id)sender{
    _locationLabel.hidden = YES;
    [self.activityIndic startAnimating];
    self.activityIndic.hidden = NO;
    
    [self mc_GetCurrentLocationWithCompletionBlock:^(LocationHandler *lctHandler){
        [self.activityIndic stopAnimating];
        self.activityIndic.hidden = YES;
        _locationLabel.hidden = NO;
        if (lctHandler.result == LocationHandlerSuccessed) {
            _locationLabel.text = lctHandler.city;
        }else if (lctHandler.result == LocationHandlerFailed){
            if (lctHandler.authorizationStatus == kCLAuthorizationStatusDenied) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unalbe to Get Your Location without Your Permission." message:@"Please Allow \"Morning Call\" to Access Your Location. \n This can be configured in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Unalbe to Get Your Location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

#pragma - Getter and setter

- (UIActivityIndicatorView *)activityIndic{
    if (!_activityIndic) {
        _activityIndic = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndic.center = CGPointMake(_locationLabel.frame.origin.x+_locationLabel.frame.size.width-_activityIndic.bounds.size.width/2, _locationLabel.center.y);
        _activityIndic.hidden = YES;
        [_locationLabel.superview addSubview:_activityIndic];
    }
    return _activityIndic;
}


#pragma - Private Functions

- (void)adjustCellLayout{
    _locationLabel.center = CGPointMake(self.tableView.frame.size.width-_locationLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator, 30);
}

@end
