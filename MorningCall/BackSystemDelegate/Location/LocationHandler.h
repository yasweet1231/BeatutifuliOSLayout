//
//  LocationHandler.h
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//@protocol LocationHandlerDelegate;

typedef enum {
    LocationHandlerNotFinished = 0,
    LocationHandlerFailed,
    LocationHandlerSuccessed,
}LocationHandlerResult;

@interface LocationHandler : NSObject <CLLocationManagerDelegate>
@property (weak, nonatomic) NSString    *city;
@property (weak ,nonatomic) NSString    *country;
@property (weak, nonatomic) NSString    *latitude;
@property (weak, nonatomic) NSString    *longitude;
@property (nonatomic, assign) LocationHandlerResult result;
@property (nonatomic, assign) CLAuthorizationStatus authorizationStatus;

- (void)getCurrentLocationWithCompletionBlock:(void(^)(LocationHandler *location))block;
@end

