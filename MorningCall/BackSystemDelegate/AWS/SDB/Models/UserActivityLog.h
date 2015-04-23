//
//  UserActivityLog.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActivityLog : NSObject

@property (nonatomic, strong) NSString  *userActivityLogId;

@property (nonatomic, strong) NSString  *userId;

@property (nonatomic, strong) NSString  *content;

@property (nonatomic, strong) NSString  *time;

@end
