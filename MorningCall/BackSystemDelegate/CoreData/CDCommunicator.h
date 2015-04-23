//
//  CDCommunicator.h
//  MorningCall
//
//  Created by Tian Tian on 2/23/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "CDAlarmSound.h"

@interface NSObject (CDCommunicator)

- (NSManagedObjectContext *)usingContext;

- (NSArray *)cd_GetAllCDAlarmSoundsBeforeDate:(NSDate *)bfDate;
- (void)cd_ClearAllCDAlarmSounds;
- (CDAlarmSound *)cd_GetCDAlarmSoundWithAlarmId:(NSString *)alarmId;

@end
