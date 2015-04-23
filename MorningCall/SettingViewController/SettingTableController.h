//
//  SettingTableController.h
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableController : UITableViewController

@property (strong, nonatomic) IBOutlet UIButton     *userIconButton;
//@property (strong, nonatomic) IBOutlet UIButton     *userNameButton;
@property (strong, nonatomic) IBOutlet UIButton     *msgButton;
@property (strong, nonatomic) IBOutlet UILabel      *userNameLabel;

@property (strong, nonatomic) IBOutlet UIButton     *backButton;

@end
