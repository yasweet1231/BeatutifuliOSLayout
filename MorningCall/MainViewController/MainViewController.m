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
//#import "ALTableCellTableCellB.h"

#import "M13ProgressViewRing.h"
#import "EditAlarmTable.h"

#import "SearchFrindViewController.h"
#import "RecordViewController.h"

#import "LayoutExtension.h"
#import "Brain.h"

@interface MainViewController () <MainViewBotListViewDelegate, UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation MainViewController
{
    M13ProgressViewRing *progressView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Bot User List
    _botUserListView.controlDelegate = self;
    
    NSMutableArray *iconArray = [NSMutableArray array];
    [iconArray addObject:[UIImage imageWithData:[Me alive].myIcon]];
    for (NSDictionary *aDic in [Me alive].myFriendIdList) {
        NSData *imgData = [aDic objectForKey:KEY_USER_ICON];
        [iconArray addObject:[UIImage imageWithData:imgData]];
    }
    [_botUserListView setupViewImgArray:iconArray];
    
    // Alarm List
    _alarmListTable.backgroundColor = [UIColor clearColor];
    _alarmListTable.delegate = self;
    _alarmListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    refresher.tintColor = self.mc_grayYellow;
    [refresher addTarget:self action:@selector(refreshAlarmTalbe:) forControlEvents:UIControlEventValueChanged];
    [_alarmListTable addSubview:refresher];
    
    [_addNewAlarmButton addTarget:self action:@selector(showEditAlarmView:) forControlEvents:UIControlEventTouchUpInside];
    
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
}

#pragma - MARK
#pragma - Gestures

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [_botUserListView swipeRight];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [_botUserListView swipeLeft];
    }
}

#pragma - MARK
#pragma - Button Action

- (void)refreshAlarmTalbe:(UIRefreshControl *)sender{
    [self mc_AlarmListRefresh];
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
    [self mc_SetEditingAlarmWithAlarmIndex:-1];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:navi animated:YES completion:^{
        [new setPickedAlarmTime:[[NSDate date] mc_LocalHHMMString]];
    }];
}

- (void)cellRightButtonShouldDownload:(UIButton *)sender{
//    NSLog(@"tag : %d",sender.tag);
    
    [self mc_SetEditingAlarmWithAlarmIndex:sender.tag];
    ALTableCellTableCellA *animationCell = (ALTableCellTableCellA *)[_alarmListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
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
    self.mc_EditingALarm.downloadFlag = NO;
    self.mc_EditingALarm.soundType = AlarmSoundTypeUser;
    
    NSInteger index = [self.mc_AlarmList indexOfObject:self.mc_EditingALarm];
    if (index == NSNotFound) {
        NSLog(@"ERROR");
    }
    NSIndexPath *shouldRefresh = [NSIndexPath indexPathForRow:index inSection:0];
    ALTableCellTableCellA *animationCell = (ALTableCellTableCellA *)[_alarmListTable cellForRowAtIndexPath:shouldRefresh];
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
    return self.mc_AlarmList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isMe = self.mc_FriendDataCase == nil;
    _addNewAlarmButton.hidden = !isMe;
    
    ALTableCellTableCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"ALTableCellTableCellA" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.rightButton.tag = indexPath.row;
    
    Alarm *anAlamr = [self.mc_AlarmList objectAtIndex:indexPath.row];
    cell.timeLabel.text = anAlamr.time;
    cell.memoLabel.text = anAlamr.memo;
    cell.alarmStatus.image = anAlamr.soundType == AlarmSoundTypeDefault ? [UIImage imageNamed:@"theme1_iconAlarm.png"] : [UIImage imageNamed:@"theme1_iconByVoice.png"];
    cell.contentView.alpha = anAlamr.on ? 1.f : 0.5f;
    if (anAlamr.on) {
        cell.midBG.alpha = 0.2f;
        [cell.contentView sendSubviewToBack:cell.midBG];
    }else{
        cell.midBG.alpha = 0.5f;
        [cell.contentView bringSubviewToFront:cell.midBG];
    }
    
    
    if ([anAlamr.repeateFlag isEqualToString:@"1111100"]) {
        cell.repeatLabel.text = @"weekdays";
    }else if ([anAlamr.repeateFlag isEqualToString:@"0000011"]){
        cell.repeatLabel.text = @"weekends";
    }else if ([anAlamr.repeateFlag isEqualToString:@"1111111"]){
        cell.repeatLabel.text = @"everyday";
    }else{
        cell.repeatLabel.text = @"";
    }
    
    if (isMe) {
        if (anAlamr.downloadFlag) {
            [cell shrinkMidBGWithRightButtonImg:[UIImage imageNamed:@"SI_download.png"]];
        }else{
            [cell expandMidBG];
        }
        [cell.rightButton removeTarget:self action:@selector(cellRightButtonShouldRecord:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(cellRightButtonShouldDownload:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if (anAlamr.soundType == AlarmSoundTypeDefault) {
            [cell shrinkMidBGWithRightButtonImg:[UIImage imageNamed:@"SI_speaker.png"]];
        }else{
            [cell expandMidBG];
        }
        [cell.rightButton removeTarget:self action:@selector(cellRightButtonShouldDownload:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(cellRightButtonShouldRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mc_FriendDataCase!=nil) {
        return;
    }
    EditAlarmTable *new;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        new = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }else{
        new = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"EditAlarmTable"];
    }
    new.title = @"Edit Alarm";
    [self mc_SetEditingAlarmWithAlarmIndex:indexPath.row];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:navi animated:YES completion:^{
        ALTableCellTableCellA *cell = (ALTableCellTableCellA *)[tableView cellForRowAtIndexPath:indexPath];
        [new setPickedAlarmTime:cell.timeLabel.text];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.mc_FriendDataCase==nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self mc_AlarmListDeleteAlarmAtIndex:indexPath.row];
        [_alarmListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma - Others

- (void)mainViewBotListView:(MainViewBotListView *)mainViewBotListView didSelectedItem:(NSInteger)itemIndex{
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
        NSString *showUser;
        if (itemIndex==0) {
            showUser = [Me alive].privateInfo.userId;
        }else{
            NSDictionary *theDic = [[Me alive].myFriendIdList objectAtIndex:itemIndex-1];
            showUser = [theDic objectForKey:KEY_USER_ID];
        }
        [self mc_SetShowingUserId:showUser];
        [self mc_AlarmListRefresh];
        [self refreshWeatherPanelWithCurrentUserCase];
        [_alarmListTable reloadData];
        return;
    }
    
    if (itemIndex==0) {
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
#pragma - WeatherPanel

- (void)refreshWeatherPanelWithCurrentUserCase{
    [UIView animateWithDuration:0.2 animations:^{
        _weatherPanel.center = CGPointMake(CGRectGetWidth(self.view.bounds)+CGRectGetWidth(_weatherPanel.bounds)/2, _weatherPanel.center.y);
    }completion:^(BOOL finished){
        
        void (^ShowWeatherPanel)(Weather *weather,NSString *city,NSString *showDate)
        = ^(Weather *showWeather,NSString *city,NSString *showDate){
            _weatherIcon.image = showWeather.weatherIcon;
            _tempHighLabel.text = [NSString stringWithFormat:@"%@ºC",showWeather.tempHigh];
            _tempLowLabel.text = [NSString stringWithFormat:@"%@ºC",showWeather.tempLow];
            _cityLabel.text = city;
            _dateLabel.text = showDate;
            [UIView animateWithDuration:.6f delay:0
                 usingSpringWithDamping:.4f initialSpringVelocity:10.0f
                                options:0 animations:^{
                                    _weatherPanel.center = CGPointMake(CGRectGetWidth(self.view.bounds)-CGRectGetWidth(_weatherPanel.bounds)/2, _weatherPanel.center.y);
                                } completion:nil];
        };
        
        if (self.mc_FriendDataCase == nil) {
            [self mc_GetCurrentLocationWithCompletionBlock:^(LocationHandler *lctHandler){
                if (lctHandler.result == LocationHandlerSuccessed) {
                    [Me alive].privateInfo.city = lctHandler.city;
                    [Me alive].privateInfo.country = lctHandler.country;
                    [Me alive].privateInfo.latitude = lctHandler.latitude;
                    [Me alive].privateInfo.longitude = lctHandler.longitude;
                    [[Me alloc] refreshMyWeather];
                    ShowWeatherPanel([Me alive].myWeather,
                                     [Me alive].privateInfo.city,
                                     [[NSDate date] mc_DisplayDateWithTimeZone:[NSTimeZone timeZoneWithName:[Me alive].privateInfo.timezone]]);
                }
            }];
        }else{
            ShowWeatherPanel(self.mc_FriendDataCase.weather,
                             self.mc_FriendDataCase.privateInfo.city,
                             [[NSDate date] mc_DisplayDateWithTimeZone:[NSTimeZone timeZoneWithName:self.mc_FriendDataCase.privateInfo.timezone]]);
        }
    }];
}

#pragma - MARK
#pragma - test

- (IBAction)testFunction:(id)sender {
    ALarmOnViewController *show = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ALarmOnViewController"];
    [self presentViewController:show animated:YES completion:nil];
}
@end
