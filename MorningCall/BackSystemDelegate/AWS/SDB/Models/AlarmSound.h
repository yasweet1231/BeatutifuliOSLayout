//
//  AlarmSound.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmSound : NSObject

@property (strong, nonatomic) NSString  *soundLink;     // AlarmSount itemName

@property (strong, nonatomic) NSString  *fromId;
@property (strong, nonatomic) NSString  *toId;

@end
