//
//  CurrentVariables.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Me.h"
#import "FriendDataCase.h"

#import "DefaultAlarmSounds.h"
#import "VerificationEmail.h"
#import "AlarmSound.h"

#import "LocationHandler.h"

@interface CurrentVariables : NSObject

@property (nonatomic, strong) FriendDataCase        *showingFriendDC;

@property (nonatomic, strong) Alarm                 *editingAlarm;

@property (nonatomic, strong) DefaultAlarmSounds    *defaultAlarmSounds;

@property (nonatomic, strong) NSMutableArray        *systemNotificationList;        // array of  SYstemNotification

@property (nonatomic, strong) LocationHandler       *lctHandler;


@end
