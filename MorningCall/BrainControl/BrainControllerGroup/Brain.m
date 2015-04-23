//
//  Brain.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Brain.h"
#import "TestCase.h"

#import "LocalNotificationHandler.h"

static CurrentVariables *currentCase = nil;

@implementation NSObject (BrainExtension)

#pragma - Initializers

- (CurrentVariables *)currentCase{
    if (currentCase == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentCase = [[CurrentVariables alloc] init];
        });
    }
    return currentCase;
}

#pragma - current user

- (void)mc_SetShowingUserId:(NSString *)userId{
    [self currentCase].showingFriendDC =
    [userId isEqualToString:[[UIDevice currentDevice].identifierForVendor UUIDString]]?
    nil :
    [TestCase testFriendDataCaseWithUserId:userId];
    
//    [self currentCase].showingFriendDC =
//    [userId isEqualToString:[[UIDevice currentDevice].identifierForVendor UUIDString]]?
//    nil :
//    [FriendDataCase friendDataCaseWithUserId:userId];
}
- (FriendDataCase *)mc_FriendDataCase{
    return [self currentCase].showingFriendDC;
}

#pragma - MARK
#pragma - Alarm List

- (NSMutableArray *)mc_AlarmList{
    return [self currentCase].showingFriendDC == nil ? [Me alive].myAlarmList : (NSMutableArray *)[self currentCase].showingFriendDC.alarmList;
}
- (void)mc_AlarmListRefresh{
    if ([self currentCase].showingFriendDC == nil) {
        [[Me alive] refreshMyAlarmList];
    }
    else{
        [[self currentCase].showingFriendDC refreshAlarmList];
    }
}
- (void)mc_AlarmListDeleteAlarmAtIndex:(NSInteger)index{
    if ([self currentCase].showingFriendDC != nil) {
        NSLog(@"Unalbe to delete alarms of friends.");
        return;
    }
    if ([Me alive].myAlarmList.count<index+1) {
        NSLog(@"ERROR : Try to delete an item (idx : %d) from alarm array (count:%d)",index,[Me alive].myAlarmList.count);
        return;
    }
    [[Me alive].myAlarmList removeObjectAtIndex:index];
}

#pragma - MARK
#pragma - Edit Alarm

- (Alarm *)mc_EditingALarm{
    return [self currentCase].editingAlarm;
}

- (void)mc_SetEditingAlarmWithAlarmIndex:(NSInteger)index{
    if ([self currentCase].showingFriendDC != nil) {
        NSLog(@"Unalbe to edit alarms of friends.");
        return;
    }
    if (index>=0 && index<[Me alive].myAlarmList.count) {
        [self currentCase].editingAlarm = [[Me alive].myAlarmList objectAtIndex:index];
    }else{
        [self currentCase].editingAlarm = [[Alarm alloc] init];
        [self currentCase].editingAlarm.soundType = AlarmSoundTypeDefault;
        [self currentCase].editingAlarm.downloadFlag = NO;
        [self currentCase].editingAlarm.timezone = [NSTimeZone localTimeZone].name;
        [self currentCase].editingAlarm.soundName = [self mc_DefaultAlarmSounds].defaultSoundName;//[[NSUserDefaults standardUserDefaults] stringForKey:KEY_DEFAULT_ALARM_SOUND_NAME];
        [self currentCase].editingAlarm.alarmId = [TestCase testALarmID];
    }
}

- (void)mc_AddNewAlarm{
    if ([self currentCase].showingFriendDC != nil) {
        NSLog(@"Unalbe to add alarms to friends.");
        return;
    }
    [self mc_ScheduleLocalNotificationsForAlarm:[self currentCase].editingAlarm];
    [[Me alive].myAlarmList addObject:[self currentCase].editingAlarm];
}

- (void)mc_DeleteEditingAlarm{
    if ([self currentCase].showingFriendDC != nil) {
        NSLog(@"Unalbe to delete alarms of friends.");
        return;
    }
    [LocalNotificationHandler cancelLocalNotificationWithAlarmId:[self mc_EditingALarm].alarmId];
    if ([[Me alive].myAlarmList indexOfObject:[self mc_EditingALarm]] != NSNotFound) {
        [[Me alive].myAlarmList removeObject:[self mc_EditingALarm]];
    }
}

- (void)mc_RescheduleEditingAlarm{
    [LocalNotificationHandler cancelLocalNotificationWithAlarmId:[self mc_EditingALarm].alarmId];
    [self mc_ScheduleLocalNotificationsForAlarm:[self mc_EditingALarm]];
}

#pragma - MARK
#pragma - Default Alarm Sounds

- (DefaultAlarmSounds *)mc_DefaultAlarmSounds{
    if ([self currentCase].defaultAlarmSounds == nil) {
        [self currentCase].defaultAlarmSounds = [[DefaultAlarmSounds alloc] init];
    }
    return [self currentCase].defaultAlarmSounds;
}

- (void)mc_DefaultAlarmSoundsRelease{
    [self currentCase].defaultAlarmSounds = nil;
}

#pragma - Location
- (LocationHandler *)mc_LocationHandler{
    if ([self currentCase].lctHandler == nil) {
        [self currentCase].lctHandler = [[LocationHandler alloc] init];
    }
    return [self currentCase].lctHandler;
}

- (void)mc_GetCurrentLocationWithCompletionBlock:(void(^)(LocationHandler *location))block{
    [[self mc_LocationHandler] getCurrentLocationWithCompletionBlock:block];
}

#pragma - Accessories
- (NSString *)mc_GenerateRamdomString{
    return @"12312414fgdsg";
}
//- (NSString *)mc_StandardPhoneNumberWithOriginalPhoneNumber:(NSString *)oriPN{
//    if ([self currentCase].phoneFormat == nil) {
//        [self currentCase].phoneFormat = [[RMPhoneFormat alloc] init];
//    }
//    if ([[self currentCase].phoneFormat isPhoneNumberValid:oriPN]) {
//        [[self currentCase].phoneFormat format:oriPN];
//    }
//    return nil;
//}
//- (void)mc_PhoneFormatRelease{
//    [self currentCase].phoneFormat = nil;
//}

#pragma - MARK
#pragma - Private Methods

#pragma - Alarm Scheduler

- (void)mc_ScheduleLocalNotificationsForAlarm:(Alarm *)theAlarm{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSISO8601Calendar];
    NSDateComponents *dateComps;
    
    if ([theAlarm.repeateFlag isEqualToString:@"0000000"]) {
        dateComps = [[NSDateComponents alloc] init];
        [dateComps setDay:[TimeCalculation getStandardDayFromDate:[NSDate date]]];
        [dateComps setMonth:[TimeCalculation getStandardMonthFromDate:[NSDate date]]];
        [dateComps setYear:[TimeCalculation getStandardYearFromDate:[NSDate date]]];
        
        NSInteger location = [theAlarm.time rangeOfString:@":"].location;
        [dateComps setHour:[theAlarm.time substringToIndex:location].integerValue];
        [dateComps setMinute:[theAlarm.time substringFromIndex:location+1].integerValue];
        
        [dateComps setSecond:0];
        NSDate *alarmTime = [calendar dateFromComponents:dateComps];
        
        if ([[NSDate date] compare:alarmTime] == NSOrderedDescending) {
            alarmTime = [NSDate dateWithTimeInterval:60*60*24 sinceDate:alarmTime];
        }
        
        [LocalNotificationHandler scheduleLocalNotificationWithDate:alarmTime
                                                               memo:theAlarm.memo
                                                            alarmId:theAlarm.alarmId
                                                          soundName:theAlarm.soundName
                                                       repeatWeekly:NO];
        return;
    }
    
    NSInteger currentWeekday = [TimeCalculation getWeekdayNumberFromDate:[NSDate date]];
    NSString *check = [NSString stringWithFormat:@"%@%@",
                       [theAlarm.repeateFlag substringFromIndex:currentWeekday-1],
                       [theAlarm.repeateFlag substringToIndex:currentWeekday-1]];
    
    for (NSInteger i = 1; i< 8; i++) {
        if (![[check substringToIndex:1]isEqualToString:@"0"]) {
            dateComps = [[NSDateComponents alloc] init];
            [dateComps setDay:[TimeCalculation getStandardDayFromDate:[NSDate date]]];
            [dateComps setMonth:[TimeCalculation getStandardMonthFromDate:[NSDate date]]];
            [dateComps setYear:[TimeCalculation getStandardYearFromDate:[NSDate date]]];
            
            NSInteger location = [theAlarm.time rangeOfString:@":"].location;
            [dateComps setHour:[theAlarm.time substringToIndex:location].integerValue];
            [dateComps setMinute:[theAlarm.time substringFromIndex:location+1].intValue];
            
            [dateComps setSecond:0];
            NSDate *alarmTime = [calendar dateFromComponents:dateComps];
            alarmTime = [NSDate dateWithTimeInterval:60*60*24*(i-1) sinceDate:alarmTime];
            [LocalNotificationHandler scheduleLocalNotificationWithDate:alarmTime
                                                                   memo:theAlarm.memo
                                                                alarmId:theAlarm.alarmId
                                                              soundName:theAlarm.soundName
                                                           repeatWeekly:YES];
        }
        check = [check substringFromIndex:1];
    }
}


// TEST
- (void)test_CheckAllLocalNotifications{
    NSLog(@"local notification count : %d",[UIApplication sharedApplication].scheduledLocalNotifications.count);
    for (UILocalNotification *aNoti in [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSLog(@"fire date : %@, repeated interval : %u",aNoti.fireDate,aNoti.repeatInterval);
    }
}

@end
