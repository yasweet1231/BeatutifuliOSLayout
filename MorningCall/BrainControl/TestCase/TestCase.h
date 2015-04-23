//
//  TestCase.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Brain.h"

@interface TestCase : NSObject

+ (Me *)testMe;

//+ (NSMutableArray *)alarmsForUserId:(NSString *)userId;

//+ (Weather *)weatherForUserId:(NSString *)userId;

+ (NSString *)testALarmID;

+ (FriendDataCase *)testFriendDataCaseWithUserId:(NSString *)userId;

@end
