//
//  TimeCalculation.m
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "TimeCalculation.h"

@implementation TimeCalculation

+(NSInteger)getStandardDayFromDate:(NSDate *)_aDate{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"dd"];
    [aFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSISO8601Calendar]];
    //    [aFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [aFormatter stringFromDate:_aDate].integerValue;
}

+(NSInteger)getStandardMonthFromDate:(NSDate *)_aDate{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM"];
    [aFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSISO8601Calendar]];
    //    [aFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [aFormatter stringFromDate:_aDate].integerValue;
}

+(NSInteger)getStandardYearFromDate:(NSDate *)_aDate{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy"];
    [aFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSISO8601Calendar]];
    //    [aFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [aFormatter stringFromDate:_aDate].integerValue;
}

+(NSInteger)getWeekdayNumberFromDate:(NSDate *)aDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:aDate];
    return [comps weekday]-1;
}

@end
@implementation NSString (MCExtension)

@end

@implementation NSDate (MCExtension)
- (NSString *)mc_LocalMMDDString{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd"];
    [aFormatter setLocale:[NSLocale currentLocale]];
    return [aFormatter stringFromDate:self];
}
- (NSString *)mc_LocalHHMMString{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"HH:mm"];
    [aFormatter setLocale:[NSLocale currentLocale]];
    return [aFormatter stringFromDate:self];
}
- (NSString *)mc_DisplayDateWithTimeZone:(NSTimeZone *)timezone{
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MMM dd"];
    [aFormatter setTimeZone:timezone];
    [aFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    return [aFormatter stringFromDate:self];
    
    return nil;
}
@end
