//
//  CDCommunicator.m
//  MorningCall
//
//  Created by Tian Tian on 2/23/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "CDCommunicator.h"
#import "AppDelegate.h"

@implementation NSObject (CDCommunicator)

- (NSManagedObjectContext *)usingContext{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate managedObjectContext];
}

- (NSArray *)cd_GetAllCDAlarmSoundsBeforeDate:(NSDate *)bfDate{
    NSString *entityName = NSStringFromClass([CDAlarmSound class]);
    //    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesp = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:[self usingContext]];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entityDesp];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@",bfDate];
    [req setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData = [[self usingContext] executeFetchRequest:req error:&error];
    
    if (matchingData.count>0) {
        //        for (CDModel *aMode in matchingData) {
        //            NSLog(@"CD object ID : %@",aMode.objectID);
        //        }
        return matchingData;
    }
    
    if (error) NSLog(@"ERROR:%@",error);
    if ([matchingData count]==0) NSLog(@"No Sample Models in CoreData.");
    return nil;
}
- (void)cd_ClearAllCDAlarmSounds{
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:NSStringFromClass([CDAlarmSound class]) inManagedObjectContext:[self usingContext]]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [[self usingContext] executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [[self usingContext] deleteObject:car];
    }
    NSError *saveError;
    [[self usingContext] save:&saveError];
}
- (CDAlarmSound *)cd_GetCDAlarmSoundWithAlarmId:(NSString *)alarmId{
    NSString *entityName = NSStringFromClass([CDAlarmSound class]);
    //    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesp = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:[self usingContext]];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entityDesp];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(alarmId == %@) AND (isWaitingPlay == 1)",alarmId];
    [req setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData = [[self usingContext] executeFetchRequest:req error:&error];
    
    if (matchingData.count==1) {
        return (CDAlarmSound *)[matchingData objectAtIndex:0];
    }
    else{
        if (matchingData.count>1) {
            NSLog(@"WARN : Alarm Sound (ID : %@) has %lu waiting Play objects in CoreData",alarmId,(unsigned long)matchingData.count);
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                         ascending:YES];
            NSArray *results = [matchingData sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            return (CDAlarmSound *)[results lastObject];
        }else{
            NSLog(@"ERROR : Alarm Sound (ID : %@) has no waiting Play object in CoreData",alarmId);
        }
    }
    
    if (error) NSLog(@"ERROR:%@",error);
    return nil;
}

@end
