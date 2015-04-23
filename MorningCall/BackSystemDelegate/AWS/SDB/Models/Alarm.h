//
//  Alarm.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    AlarmSoundTypeDefault,
    AlarmSoundTypeUser,
}AlarmSoundType;
@interface Alarm : NSObject

@property (strong, nonatomic) NSString          *alarmId;

@property (strong, nonatomic) NSString          *userId;

@property (assign, nonatomic) BOOL              on;        // on, off, snooze,

@property (strong, nonatomic) NSString          *timezone;

// setting items get from page
@property (strong, nonatomic) NSString          *time;

@property (strong, nonatomic) NSString          *memo;

@property (strong, nonatomic) NSString          *repeateFlag;   // 0000000 ~ 1111111

@property (assign, nonatomic) AlarmSoundType    soundType;

@property (strong, nonatomic) NSString          *soundName;

@property (assign, nonatomic) BOOL              downloadFlag;
//@property (strong, nonatomic) NSNumber      *snoozeTime;

@end
