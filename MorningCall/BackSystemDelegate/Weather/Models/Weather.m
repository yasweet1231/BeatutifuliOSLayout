//
//  Weather.m
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (instancetype)weatherWithLatitude:(double)latitude longitude:(double)longitude{
    return [[Weather alloc] initWithLatitude:latitude longitude:longitude];
}

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude{
    self = [super init];
    if (self) {
        _location = CLLocationCoordinate2DMake(latitude, longitude);
        [self fetchDailyForecastForLoction:_location];
    }
    return self;
}

- (void)fetchDailyForecastForLoction:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSDictionary *topDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (!topDic) {
        NSLog(@"Failed");
    }
    
    //    NSLog(@"%@",topDic);
    
    NSDictionary *todayData = [[NSDictionary alloc] initWithDictionary:[[[NSMutableArray alloc] initWithArray:[topDic valueForKey:@"list"]] objectAtIndex:0]];
    NSDictionary *getTemp = [[NSDictionary alloc] initWithDictionary:[todayData valueForKey:@"temp"]];
    NSDictionary *weatherData = [[NSDictionary alloc] initWithDictionary:[[[NSMutableArray alloc] initWithArray:[todayData valueForKey:@"weather"]] objectAtIndex:0]];
    todayData = nil;
    
    NSString *tempCovert = (NSString *)[getTemp valueForKey:@"max"];
    _tempHigh = [NSString stringWithFormat:@"%ld",(long)(NSInteger)(tempCovert.doubleValue-32)*5/9];
    //    _tempHigh = (long)(int)_tempHigh;
    tempCovert = [getTemp valueForKey:@"min"];
    _tempLow = [NSString stringWithFormat:@"%ld",(long)(NSInteger)(tempCovert.doubleValue-32)*5/9];
    
    _weatherIcon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",
                                        [[Weather imageMap] valueForKey:[weatherData valueForKey:@"icon"]]]];
}

+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}
@end
