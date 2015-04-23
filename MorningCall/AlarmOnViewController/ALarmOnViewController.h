//
//  ALarmOnViewController.h
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALarmOnViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *memoLabel;

@property (strong, nonatomic) IBOutlet UIImageView *userIconBG;
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) IBOutlet UIButton *stopAlarmButton;

@end
