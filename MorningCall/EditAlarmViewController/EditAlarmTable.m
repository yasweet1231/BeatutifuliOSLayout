//
//  EditAlarmTable.m
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "EditAlarmTable.h"

#import "SingleItemInputView.h"
#import "LayoutExtension.h"
#import "Brain.h"

#import "SetRepeatTable.h"

#import "MainViewController.h"

@interface EditAlarmTable () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation EditAlarmTable

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = self.mc_BackgroundGreen;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditAlarm:)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveEditAlarm:)];
    
    [_deleteButton addTarget: self action:@selector(deleteAlarm:) forControlEvents:UIControlEventTouchUpInside];
    
    _memoLabel.center = CGPointMake(self.tableView.frame.size.width-_memoLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator,
                                    30);
    _onOffSwitch.center = CGPointMake(self.tableView.frame.size.width-_onOffSwitch.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator, 30);
    _soundNameLabel.center = CGPointMake(self.tableView.frame.size.width-_soundNameLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator, 30);
    _repeatLabel.center = CGPointMake(self.tableView.frame.size.width-_repeatLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator, 30);
    
    _alarmTimePicker.frame = CGRectMake(0, 0, self.tableView.frame.size.width, _alarmTimePicker.frame.size.height);
    _alarmTimePicker.tintColor = [UIColor whiteColor];
    [_alarmTimePicker selectRow:119 inComponent:0 animated:NO];
    [_alarmTimePicker selectRow:219 inComponent:2 animated:NO];
    _alarmTimePicker.showsSelectionIndicator = YES;
    _alarmTimePicker.contentMode = UIViewContentModeLeft;
    
    _memoLabel.text = self.mc_EditingALarm.memo;
    [_onOffSwitch setOn:self.mc_EditingALarm.on animated:YES];
    
    _soundNameLabel.text = self.mc_EditingALarm.soundName;
    
    [self setRepeatFlag:self.mc_EditingALarm.repeateFlag];    
}

#pragma - MARK
#pragma - Setter

- (void)setRepeatFlag:(NSString *)repeatFlag{
    _repeatFlag = repeatFlag;
    _repeatLabel.text = [self readRepeatFlag:repeatFlag];
}

#pragma - MARK
#pragma - Button Action

- (IBAction)cancelEditAlarm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveEditAlarm:(id)sender {
    NSLog(@"save alarm with time: %@",self.pickedAlarmTime);
    
    self.mc_EditingALarm.time = self.pickedAlarmTime;
    self.mc_EditingALarm.memo = _memoLabel.text;
    self.mc_EditingALarm.on = _onOffSwitch.isOn;
    self.mc_EditingALarm.repeateFlag = _repeatFlag.length!=7 ? @"0000000":_repeatFlag;
    self.mc_EditingALarm.soundName = _soundNameLabel.text;
    
    NSInteger index = [self.mc_AlarmList indexOfObject:self.mc_EditingALarm];
    MainViewController *parent;
    if ([self.navigationController.presentingViewController isKindOfClass:[MainViewController class]]) {
        parent = (MainViewController *)self.navigationController.parentViewController;
    }
    if (index == NSNotFound) {
        [self mc_AddNewAlarm];        
        [self dismissViewControllerAnimated:YES completion:^{
            if (parent) {
                [parent.alarmListTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.mc_AlarmList.count-1 inSection:0]]
                                             withRowAnimation:UITableViewRowAnimationBottom];
            }
        }];
    }else{
        [self mc_RescheduleEditingAlarm];
        [self dismissViewControllerAnimated:YES completion:^{
            if (parent) {
                [parent.alarmListTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]
                                             withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)deleteAlarm:(UIButton *)sender{
    NSInteger index = [self.mc_AlarmList indexOfObject:self.mc_EditingALarm];
    if (index == NSNotFound) {
        NSLog(@"ERROR : Try to deleting an alarm that not in the alarm list!");
        return;
    }
    MainViewController *parent;
    if ([self.navigationController.presentingViewController isKindOfClass:[MainViewController class]]) {
        parent = (MainViewController *)self.navigationController.parentViewController;
    }
    [self mc_DeleteEditingAlarm];
    [self dismissViewControllerAnimated:YES completion:^{
        if (parent) {
            [parent.alarmListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }];
}

#pragma - MARK
#pragma - PickerView

- (void)setPickedAlarmTime:(NSString *)pickedAlarmTime{
    NSInteger location = [pickedAlarmTime rangeOfString:@":"].location;
    [_alarmTimePicker selectRow:119+[pickedAlarmTime substringToIndex:location].integerValue
                    inComponent:0
                       animated:YES];
    [_alarmTimePicker selectRow:299+[pickedAlarmTime substringFromIndex:location+1].integerValue
                    inComponent:2
                       animated:YES];
}

-(NSString *)pickedAlarmTime{
    NSInteger hour = ([_alarmTimePicker selectedRowInComponent:0]+1)%24;
    NSString *hourStr = hour<10 ? [NSString stringWithFormat:@"0%d",hour] : [NSString stringWithFormat:@"%d",hour];
    NSInteger min = ([_alarmTimePicker selectedRowInComponent:2]+1)%60;
    NSString *minStr = min<10 ? [NSString stringWithFormat:@"0%d",min] : [NSString stringWithFormat:@"%d",min];
//    NSString *minite = [NSString stringWithFormat:@"%ld",(long)([_alarmTimePicker selectedRowInComponent:2]+1)%60];
//    if (minite.length==1) {
//        minite = [NSString stringWithFormat:@"0%@",minite];
//    }
//    
//    NSString *hour = [NSString stringWithFormat:@"%ld",(long)([_alarmTimePicker selectedRowInComponent:2]+1)%60];
//    if (hour.length==1) {
//        hour = [NSString stringWithFormat:@"0%@",minite];
//    }
    return [NSString stringWithFormat:@"%@:%@",hourStr,minStr];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 240;
    }else if (component == 1){
        return 1;
    }
    else if (component == 2){
        return 600;
    }
    return 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==1) {
        return 20.f;
    }
    return pickerView.frame.size.width/4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.f;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    if (component == 0) {
        NSInteger num = (row+1)%24;
        title = num < 10 ? [NSString stringWithFormat:@"0%ld",(long)num] : [NSString stringWithFormat:@"%ld",(long)num];
    }
    else if (component == 2){
        NSInteger num = (row+1)%60;
        title = num < 10 ? [NSString stringWithFormat:@"0%ld",(long)num] : [NSString stringWithFormat:@"%ld",(long)num];
    }
    else if (component == 1){
        title = @":";
    }

    if (!title) return nil;

    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:self.mc_BackgroundGreen}];
}

#pragma - MARK
#pragma - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        NSLog(@"Edit memo");
        SingleItemInputView *inputView;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            inputView = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleItemInputView"];
        }else{
            inputView = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleItemInputView"];
        }
        if (inputView) {
            inputView.parentInputArea = _memoLabel;
            inputView.title = @"Edit Memo";
            inputView.placeholder = @"memo";
            [self.navigationController pushViewController:inputView animated:YES];
        }
    }
}

#pragma - MARK
#pragma - Private Methods

- (NSString *)readRepeatFlag:(NSString *)repeatFlag{
    if ([repeatFlag isEqualToString:@"1111100"]) {
        return @"weekdays";
    }
    if ([repeatFlag isEqualToString:@"0000011"]) {
        return @"weekends";
    }
    if ([repeatFlag isEqualToString:@"1111111"]) {
        return @"everyday";
    }
    
    NSString *rtnValue = @"";
    for (NSInteger i=0; i<repeatFlag.length; i++) {
        NSString *subStr = [repeatFlag substringWithRange:NSMakeRange(i, 1)];
        rtnValue = subStr.boolValue ? [rtnValue stringByAppendingFormat:@" %@",[NSString mc_DaySymbolWithIndex:i+1]] : rtnValue;
    }
    return rtnValue;
}

@end
