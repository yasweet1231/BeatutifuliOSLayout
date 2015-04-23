//
//  DefaultAlarmSounds.m
//  MorningCall
//
//  Created by Tian Tian on 2/20/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "DefaultAlarmSounds.h"

@implementation DefaultAlarmSounds

#pragma - MARK
#pragma - Default Sound

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    _defaultAlarmSounds = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultAlarmSounds" ofType:@"plist"]];
    
    return self;
}

- (NSInteger )count{
    return self.defaultAlarmSounds.allKeys.count;
}

- (NSString *)defaultSoundName{
    NSString *defaultSoundName = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_DEFAULT_ALARM_SOUND_NAME];
    if (!defaultSoundName.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:[self displayNameWithIndex:0] forKey:KEY_DEFAULT_ALARM_SOUND_NAME];
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:KEY_DEFAULT_ALARM_SOUND_NAME];
}

- (NSString *)displayNameWithIndex:(NSInteger)index{
    NSDictionary *aSound = [self.defaultAlarmSounds objectForKey:[NSString stringWithFormat:@"%d",index]];
    return [aSound objectForKey:@"displayName"];
}

@end
