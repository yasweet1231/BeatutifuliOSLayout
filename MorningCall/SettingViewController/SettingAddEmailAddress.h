//
//  SettingAddEmailAddress.h
//  MorningCall
//
//  Created by Tian Tian on 2/25/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingAddEmailAddress : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) IBOutlet UIView *processingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;

@end
