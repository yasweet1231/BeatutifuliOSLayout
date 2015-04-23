//
//  CDAlarmSound.h
//  MorningCall
//
//  Created by Tian Tian on 2/23/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDAlarmSound : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * fromId;
@property (nonatomic, retain) NSString * alarmId;
@property (nonatomic, retain) NSNumber * isChecked;
@property (nonatomic, retain) NSData * sound;
@property (nonatomic, retain) NSNumber * isWaitingPlay;

@end
