//
//  SetRepeatTable.h
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABEL_WEEKENDS      @"weekends"
#define LABEL_WEEKDAYS      @"weekdays"
#define LABEL_EVERYDAY      @"everyday"

#define LABEL_SUNDAY        @"Su"
#define LABEL_MONDAY        @"Mo"
#define LABEL_TUESDAY       @"Tu"
#define LABEL_WEDNESDAY     @"We"
#define LABEL_THURSDAY      @"Th"
#define LABEL_FRIDAY        @"Fr"
#define LABEL_SATURDAY      @"Sa"

@interface SetRepeatTable : UITableViewController

@end

@interface NSString (DaySymbolExtension)
+ (NSString *)mc_DaySymbolWithIndex:(NSInteger)index;
@end
