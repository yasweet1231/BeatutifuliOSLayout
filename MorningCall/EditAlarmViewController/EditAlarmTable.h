//
//  EditAlarmTable.h
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmTable : UITableViewController

@property (nonatomic, setter=setPickedAlarmTime:) NSString            *pickedAlarmTime;

@property (strong, nonatomic) IBOutlet UIPickerView *alarmTimePicker;
@property (strong, nonatomic) IBOutlet UILabel      *memoLabel;
@property (strong, nonatomic) IBOutlet UISwitch     *onOffSwitch;
@property (strong, nonatomic) IBOutlet UILabel      *repeatLabel;
@property (strong, nonatomic) IBOutlet UILabel      *soundNameLabel;
@property (strong, nonatomic) IBOutlet UIButton     *deleteButton;

- (IBAction)cancelEditAlarm:(id)sender;
- (IBAction)saveEditAlarm:(id)sender;

@property (strong, nonatomic) NSString  *repeatFlag;
- (void)setRepeatFlag:(NSString *)repeatFlag;

@end
