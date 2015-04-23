//
//  TestCase.m
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "TestCase.h"
#import "Me.h"
@implementation TestCase

+ (Me *)testMe{
    
    Me *inst = nil;
    inst = [[Me alloc] init];
    
    inst.privateInfo = [[User alloc] init];
    inst.privateInfo.userId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    inst.privateInfo.alias = @"summer";
    inst.privateInfo.timezone = [NSTimeZone localTimeZone].name;
    inst.privateInfo.city = @"Okinawa";
    inst.privateInfo.deviceToken = @"";
    inst.privateInfo.endpointArn = @"";
    inst.privateInfo.country = @"JP";
    inst.privateInfo.latitude = @"";
    inst.privateInfo.longitude = @"";
    inst.privateInfo.uniqueName = @"Summer";
    
    inst.myIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"user1.png"], 1.f);
    
    inst.myWeather = [Weather weatherWithLatitude:inst.privateInfo.latitude.doubleValue longitude:inst.privateInfo.longitude.doubleValue];//[self weatherForUserId:inst.privateInfo.userId];
    
    Alarm *one = [[Alarm alloc] init];
    one.timezone = [NSTimeZone localTimeZone].name;
    one.time = @"7:00";
    one.memo = @"work morning";
    one.repeateFlag = @"1111100";
    one.soundType = AlarmSoundTypeDefault;
    one.on = YES;
    one.downloadFlag= YES;
    Alarm *two = [[Alarm alloc] init];
    two.timezone = [NSTimeZone localTimeZone].name;
    two.time = @"9:30";
    two.memo = @"rest morning";
    two.repeateFlag = @"0000011";
    two.soundType = AlarmSoundTypeUser;
    two.on = YES;
    Alarm *three = [[Alarm alloc] init];
    three.timezone = [NSTimeZone localTimeZone].name;
    three.time = @"14:00";
    three.memo = @"afternoon";
    three.repeateFlag = @"0011000";
    three.soundType = AlarmSoundTypeDefault;
    three.on = YES;
    inst.myAlarmList = (NSMutableArray *)@[one,two,three];
    
    NSData *user2Img = UIImageJPEGRepresentation([UIImage imageNamed:@"user2.png"], 1.f);
    NSData *user3Img = UIImageJPEGRepresentation([UIImage imageNamed:@"user3.png"], 1.f);
    NSArray *dic = @[@{KEY_USER_ID:@"1",KEY_USER_ICON:user2Img},
                     @{KEY_USER_ID:@"2",KEY_USER_ICON:user3Img}];
    inst.myFriendIdList = (NSMutableArray *)dic;
    //    inst.systemNotificationList;
    
    return inst;
}

+ (FriendDataCase *)testFriendDataCaseWithUserId:(NSString *)userId{
    
    if ([userId isEqualToString:@"1"]) {
        User *rtnValue = [[User alloc] init];
        rtnValue.userId = userId;
        rtnValue.alias = @"girl";
        rtnValue.timezone = @"America/New_York";
        rtnValue.city = @"New York";
        rtnValue.country =@"US";
        rtnValue.latitude = @"40.7127";
        rtnValue.longitude = @"74.0059";
        
        FriendDataCase *fdc = [[FriendDataCase alloc] init];
        fdc.privateInfo = rtnValue;
        
        for (NSDictionary *aDic in [Me alive].myFriendIdList) {
            if ([[aDic objectForKey:KEY_USER_ID] isEqualToString:userId]) {
                fdc.friendIcon = [aDic objectForKey:KEY_USER_ICON];
            }
        }
        
        fdc.weather = [Weather weatherWithLatitude:rtnValue.latitude.doubleValue longitude:rtnValue.longitude.doubleValue];
        
        Alarm *one = [[Alarm alloc] init];
        one.timezone = [NSTimeZone localTimeZone].name;
        one.time = @"6:00";
        one.memo = @"man cooking! in morning";
        one.repeateFlag = @"1111111";
        one.soundType = AlarmSoundTypeDefault;
        one.on = YES;
        Alarm *two = [[Alarm alloc] init];
        two.timezone = [NSTimeZone localTimeZone].name;
        two.time = @"7:30";
        two.memo = @"man rest morning for GYM!";
        two.repeateFlag = @"0000011";
        two.soundType = AlarmSoundTypeUser;
        two.on = YES;
        fdc.alarmList = @[one,two];
        
        return fdc;
    }
    else if ([userId isEqualToString:@"2"]){
        User *rtnValue = [[User alloc] init];
        rtnValue.userId = userId;
        rtnValue.alias = @"boy";
        rtnValue.timezone = @"Europe/London";
        rtnValue.city = @"London";
        rtnValue.country =@"UK";
        rtnValue.latitude = @"51.5072";
        rtnValue.longitude = @"0.1275";
        
        FriendDataCase *fdc = [[FriendDataCase alloc] init];
        fdc.privateInfo = rtnValue;
        
        for (NSDictionary *aDic in [Me alive].myFriendIdList) {
            if ([[aDic objectForKey:KEY_USER_ID] isEqualToString:userId]) {
                fdc.friendIcon = [aDic objectForKey:KEY_USER_ICON];
            }
        }
        
        fdc.weather = [Weather weatherWithLatitude:rtnValue.latitude.doubleValue longitude:rtnValue.longitude.doubleValue];
        
        Alarm *one = [[Alarm alloc] init];
        one.timezone = [NSTimeZone localTimeZone].name;
        one.time = @"6:30";
        one.memo = @"wait for your breakfirst :)))!";
        one.repeateFlag = @"1111111";
        one.soundType = AlarmSoundTypeUser;
        one.on = YES;
        Alarm *two = [[Alarm alloc] init];
        two.timezone = [NSTimeZone localTimeZone].name;
        two.time = @"10:30";
        two.memo = @"Dont wake me up!";
        two.repeateFlag = @"0000011";
        two.soundType = AlarmSoundTypeDefault;
        two.on = NO;
        fdc.alarmList = @[one,two];
        
        return fdc;
    }
    return nil;
}

//+ (NSMutableArray *)alarmsForUserId:(NSString *)userId{
//    if ([userId isEqualToString:[[UIDevice currentDevice].identifierForVendor UUIDString]]) {
//        Alarm *one = [[Alarm alloc] init];
//        one.timezone = [NSTimeZone localTimeZone].name;
//        one.time = @"7:00";
//        one.memo = @"work morning";
//        one.repeateFlag = @"1111100";
//        one.soundType = AlarmSoundTypeDefault;
//        one.on = YES;
//        one.downloadFlag= YES;
//        Alarm *two = [[Alarm alloc] init];
//        two.timezone = [NSTimeZone localTimeZone].name;
//        two.time = @"9:30";
//        two.memo = @"rest morning";
//        two.repeateFlag = @"0000011";
//        two.soundType = AlarmSoundTypeUser;
//        two.on = YES;
//        Alarm *three = [[Alarm alloc] init];
//        three.timezone = [NSTimeZone localTimeZone].name;
//        three.time = @"14:00";
//        three.memo = @"afternoon";
//        three.repeateFlag = @"0011000";
//        three.soundType = AlarmSoundTypeDefault;
//        three.on = YES;
//        return (NSMutableArray *)@[one,two,three];
//    }
//    else if ([userId isEqualToString:@"1"]){
//        Alarm *one = [[Alarm alloc] init];
//        one.timezone = [NSTimeZone localTimeZone].name;
//        one.time = @"6:00";
//        one.memo = @"man cooking! in morning";
//        one.repeateFlag = @"1111111";
//        one.soundType = AlarmSoundTypeDefault;
//        one.on = YES;
//        Alarm *two = [[Alarm alloc] init];
//        two.timezone = [NSTimeZone localTimeZone].name;
//        two.time = @"7:30";
//        two.memo = @"man rest morning for GYM!";
//        two.repeateFlag = @"0000011";
//        two.soundType = AlarmSoundTypeUser;
//        two.on = YES;
//        return (NSMutableArray *)@[one,two];
//    }
//    else if ([userId isEqualToString:@"2"]){
//        Alarm *one = [[Alarm alloc] init];
//        one.timezone = [NSTimeZone localTimeZone].name;
//        one.time = @"6:30";
//        one.memo = @"wait for your breakfirst :)))!";
//        one.repeateFlag = @"1111111";
//        one.soundType = AlarmSoundTypeUser;
//        one.on = NO;
//        Alarm *two = [[Alarm alloc] init];
//        two.timezone = [NSTimeZone localTimeZone].name;
//        two.time = @"10:30";
//        two.memo = @"Dont wake me up!";
//        two.repeateFlag = @"0000011";
//        two.soundType = AlarmSoundTypeDefault;
//        two.on = YES;
//        return (NSMutableArray *)@[one,two];
//    }
//    
//    return nil;
//}

//+ (Weather *)weatherForUserId:(NSString *)userId{
//    Weather *rtnValue = [Weather new];
//    if ([userId isEqualToString:[[UIDevice currentDevice].identifierForVendor UUIDString]]) {
//        rtnValue = [[Weather alloc] init];
//        rtnValue.tempHigh = @"9";
//        rtnValue.tempLow = @"2";
//        rtnValue.weatherIcon = [UIImage imageNamed:@"Sample_weather.png"];
//        rtnValue.location = CLLocationCoordinate2DMake(26.5000, 128.0000);  //okinawa
//    }
//    else if ([userId isEqualToString:@"1"]){
//        rtnValue = [[Weather alloc] init];
//        rtnValue.tempHigh = @"2";
//        rtnValue.tempLow = @"-15";
//        rtnValue.weatherIcon = [UIImage imageNamed:@"Sample_weather.png"];
//        rtnValue.location = CLLocationCoordinate2DMake(26.5000, 128.0000);  //okinawa
//
//    }
//    else if ([userId isEqualToString:@"2"]){
//        rtnValue = [[Weather alloc] init];
//        rtnValue.tempHigh = @"22";
//        rtnValue.tempLow = @"12";
//        rtnValue.weatherIcon = [UIImage imageNamed:@"Sample_weather.png"];
//        rtnValue.location = CLLocationCoordinate2DMake(26.5000, 128.0000);  //okinawa
//
//    }
//    return rtnValue;
//}

+ (NSString *)testALarmID{
    return @"testalarm";
}



@end
