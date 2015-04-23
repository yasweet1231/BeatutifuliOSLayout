//
//  FriendDataCase.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "FriendDataCase.h"

@implementation FriendDataCase

+ (instancetype)friendDataCaseWithUserId:(NSString *)friendId{
    return [[FriendDataCase alloc] initWithUserId:friendId];
}

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (!self) return nil;
    
    return self;
}

- (void)refreshAlarmList{
    
}

@end
