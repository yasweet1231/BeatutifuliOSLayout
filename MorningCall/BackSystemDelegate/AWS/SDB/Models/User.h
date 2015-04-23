//
//  User.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString      *userId;

@property (nonatomic, strong) NSString      *uniqueName;

@property (nonatomic, strong) NSString      *alias;

@property (nonatomic, strong) NSString      *timezone;

@property (nonatomic, strong) NSString      *city;

@property (nonatomic, strong) NSString      *deviceToken;

@property (nonatomic, strong) NSString      *endpointArn;

@property (nonatomic, strong) NSString      *country;

@property (nonatomic, assign) NSString      *latitude;
@property (nonatomic, assign) NSString      *longitude;

@end
