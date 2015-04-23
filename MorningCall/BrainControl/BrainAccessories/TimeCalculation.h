//
//  TimeCalculation.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeCalculation : NSObject

+(NSInteger)getStandardDayFromDate:(NSDate *)_aDate;

+(NSInteger)getStandardMonthFromDate:(NSDate *)_aDate;

+(NSInteger)getStandardYearFromDate:(NSDate *)_aDate;

+(NSInteger)getWeekdayNumberFromDate:(NSDate *)aDate;

@end

@interface NSString (MCExtension)
//- (NSDate *)mc_Date;
@end

@interface NSDate (MCExtension)
- (NSString *)mc_LocalMMDDString;
- (NSString *)mc_LocalHHMMString;
- (NSString *)mc_DisplayDateWithTimeZone:(NSTimeZone *)timezone;
//- (NSString *)mc_TimeString;
//- (NSString *)mc_DateString;
//- (NSString *)mc_DateStringWithTimeZone:(NSTimeZone *)timeZone;
@end


