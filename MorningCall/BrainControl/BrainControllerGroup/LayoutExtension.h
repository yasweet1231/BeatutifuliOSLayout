//
//  LayoutExtension.h
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (LayoutExtension)

#define TABLE CELL
- (CGFloat)tableViewCellContentRightIndentWithIndicator;
- (CGFloat)tableViewCellContentRightIndentWithoutIndicator;

#define COLOR
//- (UIColor *)backgroundGreenColor;
//- (UIColor *)textLightGreenColor;

- (UIColor *)mc_LightGreen;
- (UIColor *)mc_BackgroundGreen;
- (UIColor *)mc_HighlightedGreen;

- (UIColor *)mc_Orange;
- (UIColor *)mc_grayYellow;

@end
