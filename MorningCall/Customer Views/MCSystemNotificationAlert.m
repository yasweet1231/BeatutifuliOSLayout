//
//  MCSystemNotificationAlert.m
//  MorningCall
//
//  Created by Tian Tian on 2/23/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "MCSystemNotificationAlert.h"

@implementation MCSystemNotificationAlert

- (instancetype)initWithSystemNotification:(SystemNotification *)tSN{
    self = [super init];
    if (!self) return nil;
    
    self.systemNotification = tSN;
    self.delegate = self;
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *selectedTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"deal with the button : %@",selectedTitle);
}

@end
