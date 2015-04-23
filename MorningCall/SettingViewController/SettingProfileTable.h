//
//  SettingProfileTable.h
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingProfileTable : UITableViewController

@property (strong, nonatomic) IBOutlet UIImageView *myQRCodeImg;

@property (strong, nonatomic) IBOutlet UITableViewCell *qrCodeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *idCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *emailCell;

@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end
