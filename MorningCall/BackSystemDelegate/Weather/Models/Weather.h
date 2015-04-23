//
//  Weather.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Weather : NSObject

//Time of data receiving in unixtime GMT

@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, strong) NSString *tempLow;

@property (nonatomic, strong) NSString *tempHigh;

@property (nonatomic, strong) UIImage *weatherIcon;

+ (instancetype)weatherWithLatitude:(double)latitude longitude:(double)longitude;

@end
