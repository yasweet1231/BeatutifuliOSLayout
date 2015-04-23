//
//  MainViewBotListView.h
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewBotListViewDelegate;

@interface MainViewBotListView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, readonly) NSInteger selectingItemIndex;
@property (nonatomic, weak) id<MainViewBotListViewDelegate> controlDelegate;

- (void)setupViewImgArray:(NSArray *)imgArray;
- (NSInteger)itemCount;
- (void)swipeRight;
- (void)swipeLeft;

@end

@protocol MainViewBotListViewDelegate <NSObject>

@required

- (void)mainViewBotListView:(MainViewBotListView *)mainViewBotListView didSelectedItem:(NSInteger)itemIndex;

@end

@interface MainViewBotListViewItem : UIButton

+ (instancetype)viewItemWithLength:(CGFloat)frameLength image:(UIImage *)image;

@end
