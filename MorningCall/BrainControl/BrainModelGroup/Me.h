//
//  Me.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Weather.h"
#import "Alarm.h"
#import "User.h"

#define KEY_USER_ID     @"userId"
#define KEY_USER_ICON   @"userIcon"

@interface Me : NSObject

+ (void)initiate;
+ (instancetype)alive;

@property (nonatomic, strong) User              *privateInfo;
// S3
@property (nonatomic, strong) NSData            *myIcon;

@property (nonatomic, strong) Weather           *myWeather;
- (void)refreshMyWeather;
@property (nonatomic, strong) NSMutableArray    *myAlarmList;
- (void)refreshMyAlarmList;
@property (nonatomic, strong) NSMutableArray    *myFriendIdList;        // Array of a Dictionary with @{@"userId" : <NSString>,  @"userIcon" : <NSData>}
- (void)refreshMyFriendIdList;

#pragma - Actions
- (void)updatePrivateInfoToSDB;
- (void)updateMyIconToS3;

- (void)removeFriendWithUserId:(NSString *)userId;
- (void)addFriendWithUserId:(NSString *)userId;
@end
