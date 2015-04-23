//
//  UIButton+BBAnimation.h
//  OrigamiBB
//
//  Created by Tian Tian on 1/8/15.
//  Copyright (c) 2015 Forestism. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "POP.h"
#define ANIMATION_RIPPLE_DURATION  0.4f

@interface UIButton (BBAnimation) <UIGestureRecognizerDelegate>

- (void)rippleEffect;

- (void)rippleEffectWithDuration:(NSTimeInterval)duration completionBlock:(void(^)(void))block;

- (void)shakeButton;

- (void)pressedWithCompletionBlock:(void (^)(void))block;

- (void)pressedWithBounceCount:(CGFloat)bounceCount completionBlock:(void (^)(void))block;

- (void)pressedEffectImageLayer;
@end
