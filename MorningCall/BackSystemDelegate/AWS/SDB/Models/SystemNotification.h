//
//  SystemNotification.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SystemNotificationNone,
    SystemNotificationTryToAddYou,
    SystemNotificationAddedToYourFriendList,
    SystemNotificationRemovedYou,
    SystemNotificationSentYouAlarmSound,
    SystemNotificationReceivedYourAlarmSound,
}SystemNotificationType;

#define KEY_SN_RECEIVED_TIME    @"receivedTime"

@interface SystemNotification : NSObject

@property (nonatomic, strong) NSString                  *systemNotificationId;

@property (nonatomic, assign) SystemNotificationType    systemNotificationType;

@property (nonatomic, strong) NSString                  *content;

@property (nonatomic, strong) NSString                  *time;

@property (nonatomic, strong) NSString                  *fromId;

@property (nonatomic, strong) NSString                  *toId;
@property (nonatomic, strong) NSString                  *toIdEndpointArn;
@property (nonatomic, strong) NSString                  *toIdAlias;

@end
