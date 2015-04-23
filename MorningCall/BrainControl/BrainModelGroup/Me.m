//
//  Me.m
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Me.h"

#import "TestCase.h"

static Me *sharedMe = nil;

@implementation Me

#pragma - MARK
#pragma - Initializers

+ (void)initiate{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMe = [TestCase testMe];
//        sharedMe = [[Me alloc] init];
    });
}

+ (instancetype)alive{
    if (sharedMe) {
        return sharedMe;
    }
    NSLog(@"No Me data");
    return nil;
}

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    
    self.privateInfo = [[User alloc] init];
    self.privateInfo.userId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    return self;
}

- (void)refreshMyWeather{
    self.myWeather = [Weather weatherWithLatitude:self.privateInfo.latitude.longLongValue longitude:self.privateInfo.longitude.longLongValue];
}

- (void)refreshMyAlarmList{
    
}

- (void)refreshMyFriendIdList{
    
}

- (void)updatePrivateInfoToSDB{
    
}
- (void)updateMyIconToS3{
    
}

- (void)removeFriendWithUserId:(NSString *)userId{
    
}
- (void)addFriendWithUserId:(NSString *)userId{
    
}

@end
