//
//  LocationHandler.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "LocationHandler.h"

@interface LocationHandler ()

@property (nonatomic, strong) CLLocationManager   *locationManager;
@property (nonatomic, strong) CLLocation   *currentLocation;
@property (nonatomic, strong) CLGeocoder   *geocoder;
@property (nonatomic, strong) CLPlacemark   *placemark;

@property (copy)void (^CompletionBlock)(LocationHandler *location);
@end

@implementation LocationHandler

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    self.result = LocationHandlerNotFinished;
    return self;
}

- (void)getCurrentLocationWithCompletionBlock:(void(^)(LocationHandler *location))block{
    self.CompletionBlock = block;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _geocoder = [[CLGeocoder alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    self.authorizationStatus = status;
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location service denied.");
//        if ([_delegate respondsToSelector:@selector(locationHandlerNotAllowed)]) {
//            [_delegate locationHandlerNotAllowed];
//        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"didDetermineState:%u; \n forRegion:%@",state,region);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"didEnterRegion:%@",region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"didExitRegion:%@",region);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    self.result = LocationHandlerFailed;
    self.CompletionBlock(self);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"didFinishDeferredUpdatesWithError:%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"didRangeBeacons:%@;\n inRegion:%@",beacons,region);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"didStartMonitoringForRegion:%@",region);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"didUpdateHeading:%@",newHeading);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _currentLocation = [locations lastObject];
    
    // Reverse Geocoding
    //    NSLog(@"Resolving the Address");
    [_geocoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
            _city = [NSString stringWithFormat:@"%@",_placemark.administrativeArea];
            _country = [NSString stringWithFormat:@"%@",_placemark.country];
            
            if (_currentLocation && !_longitude && !_latitude) {
                _longitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude];
                _latitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude];
            }
            
            [_locationManager stopUpdatingLocation];
//            if ([_delegate respondsToSelector:@selector(locationHandlerDidReceivedLocation:)]) {
//                [_delegate locationHandlerDidReceivedLocation:self];
//            }
            self.result = LocationHandlerSuccessed;
            self.CompletionBlock(self);
            
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    NSLog(@"didUpdateToLocation: %@", newLocation);
    _currentLocation = newLocation;
    
    // Reverse Geocoding
    //    NSLog(@"Resolving the Address");
    [_geocoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
            _city = [NSString stringWithFormat:@"%@",_placemark.administrativeArea];
            _country = [NSString stringWithFormat:@"%@",_placemark.country];
            
            if (_currentLocation && !_longitude && !_latitude) {
                _longitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.longitude];
                _latitude = [NSString stringWithFormat:@"%.8f", _currentLocation.coordinate.latitude];
            }
            
//            if ([_delegate respondsToSelector:@selector(locationHandlerDidReceivedLocation:)]) {
//                [_delegate locationHandlerDidReceivedLocation:self];
//            }
            
            [_locationManager stopUpdatingLocation];
            
            self.result = LocationHandlerSuccessed;
            self.CompletionBlock(self);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}
@end
