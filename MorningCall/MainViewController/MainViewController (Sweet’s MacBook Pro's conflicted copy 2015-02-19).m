//
//  MainViewController.m
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "MainViewController.h"

#import "SettingTableController.h"

#import "ALTableCellTableCellA.h"
#import "ALTableCellTableCellB.h"

#import "M13ProgressViewRing.h"
#import "EditAlarmTable.h"

#import "SearchFrindViewController.h"
#import "RecordViewController.h"

#import "UIViewController+LayoutExtension.h"

@interface MainViewController () <MainViewBotListViewDelegate, UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation MainViewController
{
    NSInteger itemcount;
    M13ProgressViewRing *progressView;
    ALTableCellTableCellA *animationCell;
    BOOL isMe;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Bot User List
    _botUserListView.controlDelegate = self;
    [_botUserListView setupViewImgArray:[NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"user1.png"],
                                         [UIImage imageNamed:@"user2.png"],
                                         [UIImage imageNamed:@"user3.png"],
                                         [UIImage imageNamed:@"theme1_iconAddUser.png"],nil]];
    
    
    // Alarm List Table
    _alarmListTable.backgroundColor = [UIColor clearColor];
    _alarmListTable.delegate = self;
    _alarmListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = self.mc_grayYellow;
    [refresh addTarget:self action:@selector(refreshAlarmTable:) forControlEvents:UIControlEventValueChanged];
    [_alarmListTable addSubview:refresh];
}

#pragma - MARK
#pragma - Button Action

- (void)refreshAlarmTable:(UIRefreshControl *)sender{
    [_alarmListTable reloadData];
    [sender endRefreshing];
}

- (void)showEditAlarmView:(id)sender{
    EditAlarmTable *new;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        new = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }else{
        new = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }
    new.title = @"Add Alarm";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:navi animated:YES completion:^{
        [new setPickedAlarmTime:@"15:37"];
    }];
}

- (void)cellRightButtonShouldDownload:(UIButton *)sender{
//    NSLog(@"tag : %d",sender.tag);
    animationCell = (ALTableCellTableCellA *)[_alarmListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
//    CGRect useFrame = cell.rightButton.frame;
    progressView = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    progressView.showPercentage = NO;
    progressView.center = CGPointMake(animationCell.rightButton.frame.origin.x+animationCell.rightButton.frame.size.width/2,
                                      animationCell.rightButton.frame.origin.y+animationCell.rightButton.frame.size.height/2);
    [animationCell addSubview:progressView];
    [self performSelector:@selector(setQuarter) withObject:Nil afterDelay:1];
    
}
- (void)setQuarter
{
    [progressView setProgress:.25 animated:YES];
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [progressView setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    [progressView setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [progressView setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:progressView.animationDuration + .1];
}

- (void)setComplete
{
    animationCell.rightButton.hidden = YES;
    [progressView performAction:M13ProgressViewActionSuccess animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        animationCell.alarmStatus.image = [UIImage imageNamed:@"theme1_iconByVoice.png"];
        [UIView animateWithDuration:0.3 animations:^{
            progressView.alpha = 0.f;
        }completion:^(BOOL finished){
            [progressView removeFromSuperview];
            progressView = nil;
            [animationCell expandMidBG];
            animationCell = nil;
        }];
    });
}

- (void)cellRightButtonShouldRecord:(UIButton *)sender{
    RecordViewController *recordView;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        recordView = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"RecordViewController"];
    }else{
        recordView = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"RecordViewController"];
    }
    recordView.modalPresentationStyle = UIModalPresentationCustom;
    recordView.transitioningDelegate = self;
    [self presentViewController:recordView animated:YES completion:nil];
}

#pragma - MARK
#pragma - Delegates

- (void)viewDidAppear:(BOOL)animated{
    [_alarmListTable reloadData];
}

#pragma - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    if ([presented isKindOfClass:[RecordViewController class]]) {
        return (RecordViewController *)presented;
    }
    return nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if ([dismissed isKindOfClass:[RecordViewController class]]) {
        return (RecordViewController *)dismissed;
    }
    return nil;
}

#pragma - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemcount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isMe) {
        if (indexPath.row == itemcount-1) {
            ALTableCellTableCellB *cell = [tableView dequeueReusableCellWithIdentifier:@"ALTableCellTableCellB" forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(showEditAlarmView:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            ALTableCellTableCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"ALTableCellTableCellA" forIndexPath:indexPath];
            cell.tag = indexPath.row;
            cell.rightButton.tag = indexPath.row;
            [cell.rightButton removeTarget:self action:@selector(cellRightButtonShouldRecord:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightButton addTarget:self action:@selector(cellRightButtonShouldDownload:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    else{
        ALTableCellTableCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"ALTableCellTableCellA" forIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.rightButton.tag = indexPath.row;
        [cell.rightButton removeTarget:self action:@selector(cellRightButtonShouldDownload:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(cellRightButtonShouldRecord:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[ALTableCellTableCellA class]]) {
        if (isMe && indexPath.row!= itemcount-1) {
            [(ALTableCellTableCellA *)cell shrinkMidBGWithRightButtonImg:[UIImage imageNamed:@"SI_download.png"]];
        }else{
            [(ALTableCellTableCellA *)cell shrinkMidBGWithRightButtonImg:[UIImage imageNamed:@"SI_speaker.png"]];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isMe && indexPath.row==itemcount-1) {
        return 50;
    }
    else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isMe && indexPath.row==itemcount-1) {
        return;
    }
    
    EditAlarmTable *new;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        new = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }else{
        new = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }
    new.title = @"Edit Alarm";
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:navi animated:YES completion:^{
        ALTableCellTableCellA *cell = (ALTableCellTableCellA *)[tableView cellForRowAtIndexPath:indexPath];
        [new setPickedAlarmTime:cell.timeLabel.text];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return isMe && indexPath.row!=itemcount-1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        itemcount--;
        [_alarmListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        NSLog(@"editing type : %d",editingStyle);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma - Others

- (void)mainViewBotListView:(MainViewBotListView *)mainViewBotListView didSelectedItem:(NSInteger)itemIndex{
    NSLog(@"bot item selected : %ld",(long)itemIndex);
    
    if (itemIndex == mainViewBotListView.itemCount-1) {
        SearchFrindViewController *searchFriendView;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            searchFriendView = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchFrindViewController"];
        }else{
            searchFriendView = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchFrindViewController"];
        }
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:searchFriendView];
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
    
//    [_alarmListTable deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    
    if (itemIndex != mainViewBotListView.selectingItemIndex) {
        NSLog(@"reload user data");
        isMe = itemIndex==0;
        itemcount = 4;
        [_alarmListTable reloadData];
        return;
    }
    
    if (itemIndex==0) {
        NSLog(@"setting view");
        SettingTableController *settingView;
        if ([[UIDevice currentDevice].model rangeOfString:@"iPhone"].length>0) {
            settingView = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingTableController"];
        }else if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].length>0){
            settingView = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingTableController"];
        }
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:settingView];
        [self presentViewController:navi animated:YES completion:nil];
        
    }else{
        NSLog(@"user detail view");
    }
}

#pragma - MARK
#pragma - test

- (IBAction)testFunction:(id)sender {
    ALarmOnViewController *show = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ALarmOnViewController"];
    [self presentViewController:show animated:YES completion:nil];
}
@end
