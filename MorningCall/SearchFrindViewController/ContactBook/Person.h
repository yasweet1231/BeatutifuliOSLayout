//
//  Person.h
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

@interface Person : NSObject

@property (nonatomic, strong) NSString          *firstName;
@property (nonatomic, strong) NSString          *lastName;
@property (nonatomic, strong) NSMutableArray    *mails;
@property (nonatomic, strong) NSMutableArray    *phoneNumbers;

// To Seperate One Person's Different Items
@property (nonatomic, strong) NSString          *anItem;


@property (nonatomic ,assign) NSInteger         flag;

@end
