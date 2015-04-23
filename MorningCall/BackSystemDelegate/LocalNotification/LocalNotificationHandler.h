//
//  LocalNotificationHandler.h
//  MorningCall
//
//  Created by Tian Tian on 2/20/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNotificationHandler : NSObject

/*! @note       Setter and Getter
 */

/*! @note       Default Sound
 */

+ (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
                                     memo:(NSString *)memo
                                  alarmId:(NSString *)alarmId
                                soundName:(NSString *)soundName
                             repeatWeekly:(BOOL)repeatweekly;

+ (void)cancelLocalNotificationWithAlarmId:(NSString *)alarmId;

+ (void)cancelUnaValiableLoaclNotificationsAccordingAlarmIdList:(NSMutableArray *)avaliableAlarmIds;

@end
