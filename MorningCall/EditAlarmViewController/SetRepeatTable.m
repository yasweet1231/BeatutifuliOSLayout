//
//  SetRepeatTable.m
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SetRepeatTable.h"

#import "EditAlarmTable.h"
#import "LayoutExtension.h"

@interface SetRepeatTable ()
@property (nonatomic, retain) EditAlarmTable *parentEditAlarmTable;
@end

@implementation SetRepeatTable

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = self.mc_BackgroundGreen;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSetting:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveSetting:)];
}

- (void)viewDidAppear:(BOOL)animated{
    [self readRepeatInfo:self.parentEditAlarmTable.repeatLabel.text];
}

- (EditAlarmTable *)parentEditAlarmTable{
    if (!_parentEditAlarmTable) {
        UIViewController *previousView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        if ([previousView isKindOfClass:[EditAlarmTable class]]) _parentEditAlarmTable = (EditAlarmTable *)previousView;
    }
    return _parentEditAlarmTable;
}

- (void)cancelSetting:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveSetting:(id)sender{
    if (self.parentEditAlarmTable) {
        UITableViewCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        UITableViewCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        UITableViewCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        UITableViewCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
        NSString *saveDigitalFlag;
        if (cell1.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell2.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell3.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell4.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell5.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell0.accessoryType == UITableViewCellAccessoryCheckmark &&
            cell6.accessoryType == UITableViewCellAccessoryCheckmark){
            saveDigitalFlag = @"1111111";
        }
        else if (cell1.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell2.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell3.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell4.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell5.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell0.accessoryType == UITableViewCellAccessoryNone &&
                 cell6.accessoryType == UITableViewCellAccessoryNone){
            saveDigitalFlag = @"1111100";
        }
        else if (cell0.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell6.accessoryType == UITableViewCellAccessoryCheckmark &&
                 cell1.accessoryType == UITableViewCellAccessoryNone &&
                 cell2.accessoryType == UITableViewCellAccessoryNone &&
                 cell3.accessoryType == UITableViewCellAccessoryNone &&
                 cell4.accessoryType == UITableViewCellAccessoryNone &&
                 cell5.accessoryType == UITableViewCellAccessoryNone) {
//            contentText = LABEL_WEEKENDS;
            saveDigitalFlag = @"0000011";
        }
        else{
            saveDigitalFlag = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                               cell1.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell2.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell3.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell4.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell5.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell6.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0",
                               cell0.accessoryType==UITableViewCellAccessoryCheckmark?@"1":@"0"];
        }
        [self.parentEditAlarmTable setRepeatFlag:saveDigitalFlag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readRepeatInfo:(NSString *)repeatInfo{
    if (!repeatInfo.length > 0) {
        return;
    }
    
    if ([repeatInfo isEqualToString:LABEL_EVERYDAY]) {
        for (NSInteger i=0; i<7; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if ([repeatInfo isEqualToString:LABEL_WEEKDAYS]){
        for (NSInteger i=0; i<7; i++) {
            if (i>=1 && i<=5) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else if ([repeatInfo isEqualToString:LABEL_WEEKENDS]){
        for (NSInteger i=0; i<7; i++) {
            if (i==0 || i==6) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else{
        if ([repeatInfo rangeOfString:LABEL_SUNDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_MONDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_TUESDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_WEDNESDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_THURSDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_FRIDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([repeatInfo rangeOfString:LABEL_SATURDAY].length>0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    [self.tableView reloadData];
}

#pragma - MARK
#pragma - Table setting

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"row selected %ld",(long)indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.tintColor = [UIColor whiteColor];
//        UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SI_Add.png"]];
//        cell.accessoryView = checkmark;
    }
}

@end

@implementation NSString (DaySymbolExtension)
+ (NSString *)mc_DaySymbolWithIndex:(NSInteger)index{
    if (index == 0) {
        return LABEL_SUNDAY;
    }
    if (index == 1) {
        return LABEL_MONDAY;
    }
    if (index == 2) {
        return LABEL_TUESDAY;
    }
    if (index == 3) {
        return LABEL_WEDNESDAY;
    }
    if (index == 4) {
        return LABEL_THURSDAY;
    }
    if (index == 5) {
        return LABEL_FRIDAY;
    }
    if (index == 6) {
        return LABEL_SATURDAY;
    }
    if (index == 7) {
        return LABEL_SUNDAY;
    }
    return nil;
}
@end
