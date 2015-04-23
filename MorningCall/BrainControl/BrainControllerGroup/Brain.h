//
//  Brain.h
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CurrentVariables.h"
#import "TimeCalculation.h"

@interface NSObject (BrainExtension)

#pragma - Showing User : Friends
//- (NSString *)mc_ShowingUserId;
- (void)mc_SetShowingUserId:(NSString *)userId;
- (FriendDataCase *)mc_FriendDataCase;

#pragma - Alarms
#pragma - Alarms - List Getter and Setter
- (NSMutableArray *)mc_AlarmList;
- (void)mc_AlarmListRefresh;
- (void)mc_AlarmListDeleteAlarmAtIndex:(NSInteger)index;

#pragma - Alarms
#pragma - Alarms - Edit
- (Alarm *)mc_EditingALarm;
- (void)mc_SetEditingAlarmWithAlarmIndex:(NSInteger)index;
- (void)mc_AddNewAlarm;
- (void)mc_DeleteEditingAlarm;
- (void)mc_RescheduleEditingAlarm;

#pragma - Default Sounds
- (DefaultAlarmSounds *)mc_DefaultAlarmSounds;
- (void)mc_DefaultAlarmSoundsRelease;

#pragma - Location
- (void)mc_GetCurrentLocationWithCompletionBlock:(void(^)(LocationHandler *location))block;

#pragma - Accessories

- (NSString *)mc_GenerateRamdomString;
//- (NSString *)mc_StandardPhoneNumberWithOriginalPhoneNumber:(NSString *)oriPN;
//- (void)mc_PhoneFormatRelease;

#pragma - Private Methods
// Alarm Scheduler
//- (void)mc_ScheduleLocalNotificationsForAlarm:(Alarm *)theAlarm;

#pragma - TEST
- (void)test_CheckAllLocalNotifications;

@end
