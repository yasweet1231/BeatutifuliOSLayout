//
//  UIButton+BBAnimation.m
//  OrigamiBB
//
//  Created by Tian Tian on 1/8/15.
//  Copyright (c) 2015 Forestism. All rights reserved.
//

#import "UIButton+BBAnimation.h"

@implementation UIButton (BBAnimation)

- (void)rippleEffect{
    CALayer *_circleLayer = [CALayer layer];
    _circleLayer.frame = CGRectMake(0, 0, self.bounds.size.width + 30, self.bounds.size.height + 30);
    _circleLayer.cornerRadius = (_circleLayer.bounds.size.width) / 2;
    _circleLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f].CGColor;
    _circleLayer.transform = CATransform3DMakeScale(0, 0, 0);
    _circleLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self.layer insertSublayer:_circleLayer atIndex:0];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    opacity.toValue = (id)[UIColor colorWithWhite:1 alpha:0].CGColor;
    opacity.fillMode = kCAFillModeForwards;
    opacity.removedOnCompletion = NO;
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration = ANIMATION_RIPPLE_DURATION;
    
    // Transform
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    transform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transform.fillMode = kCAFillModeForwards;
    transform.removedOnCompletion = NO;
    transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transform.duration = ANIMATION_RIPPLE_DURATION;
    
    CAAnimationGroup *_animationGroupOverlay = [CAAnimationGroup animation];
    _animationGroupOverlay.animations = @[opacity, transform];
    _animationGroupOverlay.fillMode = kCAFillModeForwards;
    _animationGroupOverlay.removedOnCompletion = NO;
    _animationGroupOverlay.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    _animationGroupOverlay.duration = ANIMATION_RIPPLE_DURATION;

    [_circleLayer addAnimation:_animationGroupOverlay forKey:@"overlay"];
}

- (void)rippleEffectWithDuration:(NSTimeInterval)duration completionBlock:(void(^)(void))block{
    CALayer *_circleLayer = [CALayer layer];
    _circleLayer.frame = CGRectMake(0, 0, self.bounds.size.width + 30, self.bounds.size.height + 30);
    _circleLayer.cornerRadius = (_circleLayer.bounds.size.width) / 2;
    _circleLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f].CGColor;
    _circleLayer.transform = CATransform3DMakeScale(0, 0, 0);
    _circleLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self.layer insertSublayer:_circleLayer atIndex:0];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    opacity.toValue = (id)[UIColor colorWithWhite:1 alpha:0].CGColor;
    opacity.fillMode = kCAFillModeForwards;
    opacity.removedOnCompletion = NO;
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    opacity.duration = duration;
    
    // Transform
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    transform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transform.fillMode = kCAFillModeForwards;
    transform.removedOnCompletion = NO;
    transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transform.duration = duration;
    
    CAAnimationGroup *_animationGroupOverlay = [CAAnimationGroup animation];
    _animationGroupOverlay.animations = @[opacity, transform];
    _animationGroupOverlay.fillMode = kCAFillModeForwards;
    _animationGroupOverlay.removedOnCompletion = NO;
    _animationGroupOverlay.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    _animationGroupOverlay.duration = duration;
    
    [_circleLayer addAnimation:_animationGroupOverlay forKey:@"overlay"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)pressedWithCompletionBlock:(void (^)(void))block{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2f, 1.2f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
    POPSpringAnimation *scaleAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation2.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation2.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation2.springBounciness = 18.0f;
    if (block!=nil) {
        [scaleAnimation2 setCompletionBlock:^(POPAnimation *animation, BOOL finished){
            block();
        }];
    }
    [self.layer pop_addAnimation:scaleAnimation2 forKey:@"layerScaleSpringAnimation"];
}

- (void)pressedWithBounceCount:(CGFloat)bounceCount completionBlock:(void (^)(void))block{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9f, 0.9f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
    POPSpringAnimation *scaleAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation2.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation2.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation2.springBounciness = bounceCount;
    if (block!=nil) {
        [scaleAnimation2 setCompletionBlock:^(POPAnimation *animation, BOOL finished){
            block();
        }];
    }
    [self.layer pop_addAnimation:scaleAnimation2 forKey:@"layerScaleSpringAnimation"];
}


- (void)pressedEffectImageLayer{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.9f, 0.9f)];
    [self.imageView pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
    POPSpringAnimation *scaleAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation2.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation2.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation2.springBounciness = 18.0f;
    [self.imageView pop_addAnimation:scaleAnimation2 forKey:@"layerScaleSpringAnimation"];
}
@end
