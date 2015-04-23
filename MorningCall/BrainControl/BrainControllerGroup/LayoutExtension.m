//
//  LayoutExtension.m
//  MorningCall
//
//  Created by Tian Tian on 2/19/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "LayoutExtension.h"

@implementation NSObject (LayoutExtension)

- (CGFloat)tableViewCellContentRightIndentWithIndicator{
    return 35.f;
}

- (CGFloat)tableViewCellContentRightIndentWithoutIndicator{
    return 10.f;
}

//- (UIColor *)backgroundGreenColor{
//    return [UIColor colorWithRed:0 green:163.f/255.f blue:146.f/255.f alpha:1.f];
//}
//
//- (UIColor *)textLightGreenColor{
//    return [UIColor colorWithRed:165.f/255.f green:214.f/255.f blue:208.f/255.f alpha:1.f];
//}

- (UIColor *)mc_LightGreen{
    return [UIColor colorWithRed:165.f/255.f green:214.f/255.f blue:208.f/255.f alpha:1.f];
}
- (UIColor *)mc_BackgroundGreen{
    return [UIColor colorWithRed:0 green:163.f/255.f blue:146.f/255.f alpha:1.f];
}
- (UIColor *)mc_HighlightedGreen{
    return [UIColor colorWithRed:0 green:136.f/255.f blue:122.f/255.f alpha:1.f];
}
- (UIColor *)mc_Orange{
    return [UIColor colorWithRed:1.f green:201.f/255.f blue:10.f/255.f alpha:1.f];
}
- (UIColor *)mc_grayYellow{
    return [UIColor colorWithRed:138.f/255.f green:150.f/255.f blue:111.f/255.f alpha:1.f];
}
@end
