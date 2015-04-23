//
//  UserListTable.h
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    UserListTableTypeNearby,
    UserListTableTypeRecommendation
}UserListTableType;

@interface UserListTable : UITableViewController

@property (nonatomic, assign) UserListTableType type;

@end
