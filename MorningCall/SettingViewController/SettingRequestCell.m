//
//  SettingRequestCell.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingRequestCell.h"
#import "LayoutExtension.h"

@implementation SettingRequestCell

- (void)awakeFromNib {
    _icomImg.clipsToBounds = YES;
    _icomImg.layer.cornerRadius = _icomImg.frame.size.width/2;
    
    _acceptButton.clipsToBounds = YES;
    _acceptButton.layer.cornerRadius = 8.f;
//    NSLog(@"xlocation %f",self.frame.size.width-_acceptButton.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator);
    _acceptButton.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)-_acceptButton.frame.size.width/2-self.tableViewCellContentRightIndentWithoutIndicator, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
