//
//  UserListTableCell.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "UserListTableCell.h"
#import "LayoutExtension.h"
@implementation UserListTableCell

- (void)awakeFromNib {
    _iconImg.clipsToBounds = YES;
    _iconImg.layer.cornerRadius = _iconImg.frame.size.width/2;
    
    _addButton.clipsToBounds = YES;
    _addButton.layer.cornerRadius = 8.f;
    _addButton.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)-_addButton.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
