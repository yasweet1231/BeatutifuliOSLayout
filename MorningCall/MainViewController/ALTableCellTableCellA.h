//
//  ALTableCellTableCellA.h
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTableCellTableCellA : UITableViewCell

//@property (nonatomic, assign) BOOL  copyEditStyle;

//@property (strong, nonatomic) IBOutlet UIImageView *leftBG;
@property (strong, nonatomic) IBOutlet UIImageView  *midBG;
- (void)shrinkMidBGWithRightButtonImg:(UIImage *)image;
- (void)expandMidBG;

@property (strong, nonatomic) IBOutlet UIImageView *alarmStatus;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *memoLabel;
@property (strong, nonatomic) IBOutlet UILabel *ampmLabel;
//@property (strong, nonatomic) IBOutlet UILabel *snoozeLabel;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;

@property (strong, nonatomic) IBOutlet UIButton     *rightButton;


- (void)addGestureRecognizers;
- (void)removeGestureRecognizers;

//@property (strong, nonatomic) IBOutlet UIImageView *rightBG;
//@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
//@property (strong, nonatomic) IBOutlet UILabel *memoLabel;

@end
