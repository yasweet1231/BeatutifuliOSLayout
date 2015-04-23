//
//  DefaultAlarmSounds.h
//  MorningCall
//
//  Created by Tian Tian on 2/20/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_DEFAULT_ALARM_SOUND_NAME       @"DefaultAlarmSoundName"

@interface DefaultAlarmSounds : NSObject

@property (nonatomic, readonly) NSDictionary *defaultAlarmSounds;

- (NSInteger )count;
- (NSString *)defaultSoundName;
- (NSString *)displayNameWithIndex:(NSInteger)index;

@end
