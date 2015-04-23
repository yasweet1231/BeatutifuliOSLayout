//
//  SettingRemoveCell.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingRemoveCell.h"
#import "LayoutExtension.h"

@implementation SettingRemoveCell

- (void)awakeFromNib {
    
    _iconImg.clipsToBounds = YES;
    _iconImg.layer.cornerRadius = _iconImg.frame.size.width/2;
    
    _removeButton.clipsToBounds = YES;
    _removeButton.layer.cornerRadius = 8.f;
    _removeButton.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)-_removeButton.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
