//
//  MCSystemNotificationAlert.h
//  MorningCall
//
//  Created by Tian Tian on 2/23/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemNotification.h"

@interface MCSystemNotificationAlert : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, strong) SystemNotification    *systemNotification;

- (instancetype)initWithSystemNotification:(SystemNotification *)tSN;

@end
