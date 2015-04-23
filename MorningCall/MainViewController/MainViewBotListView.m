//
//  MainViewBotListView.m
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "MainViewBotListView.h"
#import "UIButton+BBAnimation.h"

@interface MainViewBotListView ()

@property (nonatomic, strong)   NSArray     *viewItems;

@property (nonatomic, readonly) CGFloat     viewItemLength;
@property (nonatomic, readonly) CGFloat     viewInterDistance;

@end

@implementation MainViewBotListView

- (CGFloat)viewItemLength{
    if (!self) return 0;
    return self.bounds.size.height;
}

- (CGFloat)viewInterDistance{
    return self.bounds.size.height/3;
}

- (CGAffineTransform)unselectedScale{
    CGAffineTransform t = CGAffineTransformMakeScale(0.85, 0.85);
    return CGAffineTransformScale(t, 1, 1);
}

#pragma - MARK
#pragma - BODY

- (void)setupViewImgArray:(NSArray *)imgArray{
    
    self.delegate = self;
    self.clipsToBounds = NO;
    _selectingItemIndex = -1;
    
    imgArray = [imgArray arrayByAddingObject:[UIImage imageNamed:@"theme1_iconAddUser.png"]];
    
    // generate buttons
    CGFloat startPosition = self.frame.size.width/2-self.viewItemLength/2;
    
    self.contentSize = CGSizeMake(2*startPosition + (imgArray.count)*self.viewItemLength + (imgArray.count-1)*self.viewInterDistance,
                                  self.viewItemLength);
    
    NSMutableArray *tempItems = [NSMutableArray array];
    for (NSInteger i=0; i<imgArray.count; i++) {
        UIImage *image = [imgArray objectAtIndex:i];
        if (image) {
            MainViewBotListViewItem *anItem = [MainViewBotListViewItem viewItemWithLength:self.viewItemLength image:image];
            anItem.center = CGPointMake(startPosition+self.viewItemLength*(0.5+i)+self.viewInterDistance*i,
                                        self.viewItemLength/2);
            anItem.tag = i;
            [anItem addTarget:self action:@selector(selecteViewItem:) forControlEvents:UIControlEventTouchUpInside];
            anItem.transform = [self unselectedScale];
            [tempItems addObject:anItem];
            [self addSubview:anItem];
        }
    }
    _viewItems = (NSArray *)tempItems;
    
    [self selecteViewItem:[_viewItems firstObject]];
}

- (NSInteger)itemCount{
    return _viewItems.count;
}

- (void)swipeRight{
    if ([self selectingItemIndex]==0) {
        return;
    }
    MainViewBotListViewItem *nextItem = [_viewItems objectAtIndex:[self selectingItemIndex]-1];
    [self selecteViewItem:nextItem];
}
- (void)swipeLeft{
    if ([self selectingItemIndex]==_viewItems.count-2) {
        return;
    }
    MainViewBotListViewItem *nextItem = [_viewItems objectAtIndex:[self selectingItemIndex]+1];
    [self selecteViewItem:nextItem];
}
//- (BOOL)itemIsSelecting:(NSInteger)buttonItemIndex{
//    CGFloat scrollUnit = self.viewInterDistance+self.viewItemLength;
////    MainViewBotListViewItem *item =[_viewItems objectAtIndex:buttonItemIndex];
//    return self.contentOffset.x <= scrollUnit*buttonItemIndex+2.f && self.contentOffset.x >= scrollUnit*buttonItemIndex-2.f;
//}

- (void)selecteViewItem:(MainViewBotListViewItem *)sender{
    if ([_controlDelegate respondsToSelector:@selector(mainViewBotListView:didSelectedItem:)]) {
        [_controlDelegate mainViewBotListView:self didSelectedItem:sender.tag];
    }
    
    if (sender.tag != _viewItems.count-1) {
        [self scrollToItemIndex:sender.tag];
    }
    
    if (sender.tag == _viewItems.count-1) {
        return;
    }
    for (MainViewBotListViewItem *anItem in _viewItems) {
        if (anItem == sender) {
            [anItem pressedWithCompletionBlock:nil];
        }else{
            anItem.transform = [self unselectedScale];
        }
    }
    _selectingItemIndex = sender.tag;
}

- (void)scrollToItemIndex:(NSInteger)midIndex{
    CGFloat scrollUnit = self.viewInterDistance+self.viewItemLength;
    [self setContentOffset:CGPointMake(scrollUnit*midIndex, self.contentOffset.y) animated:YES];
}

- (NSInteger)currentIndex{
    NSInteger index = self.contentOffset.x / (self.viewInterDistance+self.viewItemLength);
    if (index<0 || index>=_viewItems.count) {
        NSLog(@"ERROR : index wrong!");
        return NSNotFound;
    }
    if (index>=_viewItems.count-2) {
        return _viewItems.count-2;
    }
    
    CGFloat scrollUnit = self.viewInterDistance+self.viewItemLength;
    CGFloat restPart = self.contentOffset.x - scrollUnit*index;
    if (restPart <= scrollUnit/2) {
        return index;
    }else{
        return index+1;
    }
}

#pragma - MARK
#pragma - Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger midItemIndex = [self currentIndex];
    if (midItemIndex>=0 && midItemIndex<_viewItems.count) {
        [self selecteViewItem:[_viewItems objectAtIndex:midItemIndex]];
    }
}

@end

@implementation MainViewBotListViewItem

+ (instancetype)viewItemWithLength:(CGFloat)frameLength image:(UIImage *)image{
    return [[MainViewBotListViewItem alloc] initWithLength:frameLength image:image];
}

- (instancetype)initWithLength:(CGFloat)frameLength image:(UIImage *)image{
    self = [super initWithFrame:CGRectMake(0, 0, frameLength, frameLength)];
    if (!self) return nil;
    
    [self setImage:image forState:UIControlStateNormal];
    
//    self.layer.cornerRadius = frameLength/2;
    UIBezierPath *boundPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:frameLength/2];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = boundPath.CGPath;
    self.layer.mask = mask;
    
    CAShapeLayer *whiteBorder = [CAShapeLayer layer];
    whiteBorder.path = boundPath.CGPath;
    whiteBorder.fillColor = [UIColor clearColor].CGColor;
    whiteBorder.lineWidth = frameLength/20.f;
//    whiteBorder.borderColor = [UIColor lightTextColor].CGColor;
//    whiteBorder.borderWidth = frameLength/30.f;
    whiteBorder.strokeColor = [UIColor lightTextColor].CGColor;
    [self.layer addSublayer:whiteBorder];
//    whiteBorder.strokeColor = [UIColor lightTextColor].CGColor;
//    whiteBorder.strokeStart = 0;
//    whiteBorder.strokeEnd
    
    return self;
}

@end
