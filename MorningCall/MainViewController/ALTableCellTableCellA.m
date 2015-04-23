//
//  ALTableCellTableCellA.m
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "ALTableCellTableCellA.h"

#import "LayoutExtension.h"

//#import "POP.h"

CGFloat interDistanceBWBGs = 10.f;
CGFloat interDistanceBWCell = 10.f;

@interface ALTableCellTableCellA ()
@property (nonatomic, strong) UISwipeGestureRecognizer *addCopyButton;
@property (nonatomic, strong) UISwipeGestureRecognizer *removeCopyButton;
@property (nonatomic, strong) UIButton *tCopyButton;

@property (nonatomic, assign) CGPoint startPoint;
@end
@implementation ALTableCellTableCellA

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor = [UIColor clearColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    CGFloat leftRightLength = self.bounds.size.height-interDistanceBWCell;
//    //    _midBG.frame = CGRectMake(0, 0, rect.size.width-(leftRightLength+interDistanceBWBGs), leftRightLength);
//    _midBG.frame = CGRectMake(0, 0, self.bounds.size.width, leftRightLength);
//    _midBG.layer.cornerRadius = leftRightLength/2;
//    
//    _rightButton.frame = CGRectMake(self.bounds.size.width-leftRightLength, 0, leftRightLength, leftRightLength);
//    _rightButton.hidden = YES;
//    
//    _alarmStatus.image = [UIImage imageNamed:@"theme1_iconAlarm.png"];
//    
//    _snoozeLabel.hidden = YES;
//    _repeatLabel.hidden = YES;
}

- (void)shrinkMidBGWithRightButtonImg:(UIImage *)image{
    CGFloat leftRightLength = self.bounds.size.height-interDistanceBWCell;
    
    _rightButton.hidden = NO;
    _rightButton.alpha = 0.f;
    [_rightButton setImage:image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2f animations:^{
        _midBG.frame = CGRectMake(0, 0, self.bounds.size.width-(leftRightLength+interDistanceBWBGs), leftRightLength);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2f animations:^{
            _rightButton.alpha =0.6f;
        }];
    }];
    
}

- (void)expandMidBG{
    CGFloat leftRightLength = self.bounds.size.height-interDistanceBWCell;
    [UIView animateWithDuration:0.2f animations:^{
        _rightButton.alpha = 0.f;
    }completion:^(BOOL finished){
        _rightButton.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            _midBG.frame = CGRectMake(0, 0, self.bounds.size.width, leftRightLength);
        }];
    }];
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat rightButtonLength = rect.size.height-interDistanceBWCell;
//    _midBG.frame = CGRectMake(0, 0, rect.size.width-(leftRightLength+interDistanceBWBGs), leftRightLength);
    _midBG.frame = CGRectMake(0, 0, rect.size.width, rightButtonLength);
    _midBG.layer.cornerRadius = rightButtonLength/2;
    _midBG.clipsToBounds = YES;
    _midBG.layer.borderColor = _midBG.mc_grayYellow.CGColor;
    _midBG.layer.borderWidth = 2.f;
    
    _rightButton.frame = CGRectMake(self.bounds.size.width-rightButtonLength, 0, rightButtonLength, rightButtonLength);
    _rightButton.hidden = YES;
    
    _alarmStatus.image = [UIImage imageNamed:@"theme1_iconAlarm.png"];
    
    _repeatLabel.center = CGPointMake(self.bounds.size.width-rightButtonLength-1.6*_repeatLabel.bounds.size.width/2, _midBG.center.y);
}

- (void)addGestureRecognizers{
    _addCopyButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showCopyButton:)];
    _addCopyButton.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_addCopyButton];
    
    _removeCopyButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideCopyButton:)];
//    _removeCopyButton.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_removeCopyButton];
}

- (void)removeGestureRecognizers{
    [self removeGestureRecognizer:_addCopyButton];
    [self removeGestureRecognizer:_removeCopyButton];
}

- (void)showCopyButton:(UISwipeGestureRecognizer *)sender{
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        _startPoint = [sender velocityInView:self];
//        NSLog(@"start : %f",_startPoint.x);
//    }
//    else if (sender.state == UIGestureRecognizerStateChanged){
//        CGFloat velocity = [sender velocityInView:self].x;
//        NSLog(@"velocity : %f",velocity);
//        
//        CGFloat copyButtonLength = self.frame.size.height-interDistanceBWCell;
//        
//        CGFloat willBeXPosition = MAX(CGRectGetMidX(self.contentView.frame)+(velocity-_startPoint.x), [UIScreen mainScreen].bounds.size.width/2-copyButtonLength);
//        willBeXPosition = MIN(willBeXPosition, CGRectGetMidX([UIScreen mainScreen].bounds));
//        NSLog(@"will be : %f",willBeXPosition);
//        
//        self.contentView.center = CGPointMake(willBeXPosition, CGRectGetMidY(self.contentView.frame));
//    }
//    else{
//        _startPoint = CGPointZero;
//    }
    
    
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    positionAnimation.velocity = @2000;
//    positionAnimation.springBounciness = 20;
//    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        self.userInteractionEnabled = YES;
//    }];
//    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
//    POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
////    positionAnimation.delegate = self;
//    positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
//    [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
//    POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:@"kPOPLayerPositionX"];
//    decayAnimation.velocity = @"2000";
////    CGFloat toValue = CGRectGetMidX(self.contentView.frame)-copyButtonLength;
////    [decayAnimation setToValue:@20];
//    [self.contentView pop_addAnimation:decayAnimation forKey:@"testAnimation"];
    
    CGFloat copyButtonLength = self.frame.size.height-interDistanceBWCell;
    _tCopyButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-copyButtonLength, 0, copyButtonLength, copyButtonLength)];
    [_tCopyButton setBackgroundColor:[UIColor purpleColor]];
    [self addSubview:_tCopyButton];
    
    
    self.contentView.center = CGPointMake(CGRectGetMidX(self.contentView.frame)-copyButtonLength, CGRectGetMidY(self.contentView.frame));
    
     NSLog(@"self view %@",self.subviews);
    NSLog(@"%@", self.contentView);
    NSLog(@"content view %@",self.contentView.subviews);
}

- (void)hideCopyButton:(UISwipeGestureRecognizer *)sender{
    [_tCopyButton removeFromSuperview];
    CGFloat copyButtonLength = self.frame.size.height-interDistanceBWCell;
    
    self.contentView.center = CGPointMake(CGRectGetMidX(self.contentView.frame)+copyButtonLength, CGRectGetMidY(self.contentView.frame));
}


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//}
//
//- (void)willTransitionToState:(UITableViewCellStateMask)state{
////    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
//    if (state == UITableViewCellStateDefaultMask)
//    {
//        for (UIView *subview in self.subviews)
//        {
//            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
//            {
//                UIImageView *deleteBtn = [[UIImageView alloc]init];
//                deleteBtn.frame = CGRectMake(0, 0, subview.bounds.size.width, subview.bounds.size.height);
////                [deleteBtn setImage:[UIImage imageNamed:@"arrow_left_s11.png"]];
//                [deleteBtn setBackgroundColor:[UIColor purpleColor]];
//                [subview addSubview:deleteBtn];
//            }
//        }
//    }
//}
////UITableViewCellDeleteConfirmationView
////UITableViewCellDeleteConfirmationControl
//- (void)didTransitionToState:(UITableViewCellStateMask)state{
//    if (state == UITableViewCellStateDefaultMask)
//    {
//        for (UIView *subview in self.subviews)
//        {
//            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
//            {
//                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 33)];
//                deleteBtn.frame = CGRectMake(0, 0, subview.bounds.size.width, subview.bounds.size.height);
//                //                [deleteBtn setImage:[UIImage imageNamed:@"arrow_left_s11.png"]];
//                [deleteBtn setBackgroundColor:[UIColor purpleColor]];
//                [subview addSubview:deleteBtn];
//            }
//        }
//    }
//}

@end
