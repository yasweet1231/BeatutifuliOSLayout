//
//  FriendDataCase.h
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Weather.h"
#import "Alarm.h"
#import "User.h"

@interface FriendDataCase : NSObject

@property (nonatomic, strong) User              *privateInfo;

@property (nonatomic, strong) NSData            *friendIcon;

@property (nonatomic, strong) Weather           *weather;

@property (nonatomic, strong) NSArray           *alarmList;
- (void)refreshAlarmList;

+ (instancetype)friendDataCaseWithUserId:(NSString *)friendId;

@end
