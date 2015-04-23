//
//  LocalNotificationHandler.m
//  MorningCall
//
//  Created by Tian Tian on 2/20/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "LocalNotificationHandler.h"

@implementation LocalNotificationHandler

+ (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
                                     memo:(NSString *)memo
                                  alarmId:(NSString *)alarmId
                                soundName:(NSString *)soundName
                             repeatWeekly:(BOOL)repeatweekly{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    
    localNotification.alertBody = memo != nil ? memo : @"Alarm";
    localNotification.alertAction = @"stop";
    localNotification.soundName = soundName !=nil ? [NSString stringWithFormat:@"%@.mp3",soundName] : UILocalNotificationDefaultSoundName;

    [localNotification setCategory:@"custom_category_id"];
    
//	localNotification.alertLaunchImage = @"Theme1_logo.png";
//    localNotification.applicationIconBadgeNumber = 1;
    
    localNotification.userInfo = [NSDictionary dictionaryWithObject:alarmId forKey:@"uid"];
    
    if (repeatweekly) {
        localNotification.repeatInterval = NSWeekCalendarUnit;
    }
    
    // Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (void)cancelLocalNotificationWithAlarmId:(NSString *)alarmId{
    NSArray *eventArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
        if ([uid isEqualToString:alarmId])
        {
            //Cancelling local notification
            [[UIApplication sharedApplication] cancelLocalNotification:oneEvent];
        }
    }
}

+ (void)cancelUnaValiableLoaclNotificationsAccordingAlarmIdList:(NSMutableArray *)avaliableAlarmIds{
    if (!avaliableAlarmIds || avaliableAlarmIds.count == 0) {
        NSArray *eventArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *aEvent in eventArray) {
            [[UIApplication sharedApplication] cancelLocalNotification:aEvent];
        }
        return;
    }
    
    NSArray *eventArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    BOOL isAvaliable;
    for (UILocalNotification *aEvent in eventArray) {
        isAvaliable = NO;
        for (NSString *anAlarmId in avaliableAlarmIds) {
            if ([[aEvent.userInfo valueForKey:@"uid"] isEqualToString:anAlarmId]) {
                isAvaliable = YES;
            }
        }
        if (!isAvaliable) {
            [[UIApplication sharedApplication] cancelLocalNotification:aEvent];
        }
    }
}
@end
