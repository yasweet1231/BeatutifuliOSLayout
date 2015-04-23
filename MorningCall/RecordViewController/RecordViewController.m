//
//  RecordViewController.m
//  MorningCall
//
//  Created by Tian Tian on 2/18/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "RecordViewController.h"
#import "LayoutExtension.h"

@interface RecordViewController ()
@property (nonatomic, assign) BOOL isFading;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cancelButton.clipsToBounds = YES;
    _cancelButton.layer.cornerRadius = 8.f;
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _sendButton.clipsToBounds = YES;
    _sendButton.layer.cornerRadius = 8.f;
    [_sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    _recordButton.clipsToBounds = NO;
//    _recordButton.layer.cornerRadius = _recordButton.bounds.size.width/2;
//    _recordButton.layer.borderColor = self.mc_HighlightedGreen.CGColor;
//    _recordButton.layer.borderWidth = 2.f;
    _recordButton.delegate = self;
    _recordButton.statusTitle = self.statusLabel;
    
}

#pragma - MARK
#pragma - Button Action
- (void)cancelButtonPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendButtonPressed:(UIButton *)sender{
    NSLog(@"set audio to send");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - MARK
#pragma - Delegates

- (void)viewWillAppear:(BOOL)animated{
    _isFading = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    _isFading = YES;
}

#pragma - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (_isFading) {
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        toView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        toView.userInteractionEnabled = YES;
        
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        [fromView setUserInteractionEnabled: NO];
        
        [UIView animateWithDuration:0.3 animations:^{
            CALayer *layer = toView.layer;
            layer.zPosition = -4000;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / 300;
            layer.shadowOpacity = 0.01;
            layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
            
            toView.alpha = 0.35;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                toView.alpha = 1.0;
                
                fromView.frame = CGRectMake(0, toView.frame.size.height, fromView.frame.size.width, fromView.frame.size.height);
            }completion:^(BOOL finished){
                [transitionContext completeTransition:finished];
            }];
        }];
        
        
//        [UIView animateWithDuration:0.6f animations:^{
//            fromView.center = CGPointMake(CGRectGetMidX(transitionContext.containerView.bounds), 4*CGRectGetMidY(transitionContext.containerView.bounds));
//        }completion:^(BOOL finished){
//            [transitionContext completeTransition:finished];
//        }];
    }
    else {
        UIView *fromView = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]view];
        fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        fromView.userInteractionEnabled = NO;
        
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        CGPoint p = CGPointMake(transitionContext.containerView.center.x, 4*transitionContext.containerView.center.y);
        toView.center = p;
        
        [transitionContext.containerView addSubview:toView];
        [toView setUserInteractionEnabled: YES];
        [fromView setUserInteractionEnabled: NO];
        
        [UIView animateWithDuration:0.3 animations:^{
            toView.frame = CGRectMake(0, fromView.frame.size.height - toView.frame.size.height, toView.frame.size.width, toView.frame.size.height);
            
            CALayer *layer = fromView.layer;
            layer.zPosition = -4000;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -300;
            layer.shadowOpacity = 0.01;
            layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, 10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
            
            fromView.alpha = 0.35;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                fromView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                
                fromView.alpha = 0.5;
            }completion:^(BOOL finished){
                [transitionContext completeTransition:finished];
            }];
        }];
    }
}

#pragma - RecorderButtonDelegate
- (void)recorderButtonDidStarted{
    NSLog(_recordButton.recording ? @"start to record" : @"start to play");
}
- (void)recorderButtonDidFinished{
    NSLog(_recordButton.recording ? @"finish recordding" : @"finish playing");
}

@end

//theme1_iconRecordOrg.png
//theme1_iconRecord.png
@implementation RecordButton
{
    NSDate          *startTime;
    NSTimeInterval  recordTimeInterva;
    CAShapeLayer    *circle;
}

- (NSTimeInterval)recordedDuring{
    return recordTimeInterva;
}

- (void)awakeFromNib{
    [self setImage:[UIImage imageNamed:@"SI_Record@3x.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"SI_RecordOrg@3x.png"] forState:UIControlStateHighlighted];
    self.recording = YES;
    recordTimeInterva = 0;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width/2].CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = self.mc_LightGreen.CGColor;
    borderLayer.lineWidth = 2.f;
    [self.layer addSublayer:borderLayer];
}

- (void)startRecordAnimation{
    int radius = self.bounds.size.width/2;
    circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.mc_Orange.CGColor;
    circle.lineWidth = 6;
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = MaxRecordingTime; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"DrawCircleAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MaxRecordingTime*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_recording && circle && circle.superlayer!=nil) {
            [self setFinishRecordStatus];
        }
    });
}

- (void)stopRecordAnimation{
    [circle removeAllAnimations];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.2f;
    fade.repeatCount = 1.f;
    fade.fromValue = [NSNumber numberWithFloat:1.f];
    fade.fromValue = [NSNumber numberWithFloat:0.f];
    [circle removeFromSuperlayer];
    circle = nil;
}

- (void)startPlayAnimation{
    int radius = self.bounds.size.width/2;
    circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.mc_Orange.CGColor;
    circle.lineWidth = 6;
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = recordTimeInterva; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"DrawCircleAnimation"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(recordTimeInterva*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopPlayAnimation];
    });
}

- (void)stopPlayAnimation{
    self.selected = NO;
    [circle removeAllAnimations];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.2f;
    fade.repeatCount = 1.f;
    fade.fromValue = [NSNumber numberWithFloat:1.f];
    fade.fromValue = [NSNumber numberWithFloat:0.f];
    [circle removeFromSuperlayer];
    circle = nil;
    
    if ([_delegate respondsToSelector:@selector(recorderButtonDidFinished)]) {
        [_delegate recorderButtonDidFinished];
    }
}

- (void)setStartRecordStatus{
    _statusTitle.text = @"Release to stop...";
    [self startRecordAnimation];
    if ([_delegate respondsToSelector:@selector(recorderButtonDidStarted)]) {
        [_delegate recorderButtonDidStarted];
    }
}

- (void)setFinishRecordStatus{
    recordTimeInterva = [[NSDate date] timeIntervalSinceDate:startTime];
    
    [self stopRecordAnimation];
    if ([_delegate respondsToSelector:@selector(recorderButtonDidFinished)]) {
        [_delegate recorderButtonDidFinished];
    }
    self.recording = NO;
    [UIView animateWithDuration:0.2f animations:^{
        _statusTitle.alpha = 0.f;
    }completion:^(BOOL finished){
        _statusTitle.text = [NSString stringWithFormat:@"%d sec",(int)recordTimeInterva];
        _statusTitle.alpha =1.f;
    }];
    
    [self setImage:[UIImage imageNamed:@"SI_Play.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"SI_PlayOrg.png"] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"SI_PlayDG.png"] forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.selected) {
        return;
    }
    startTime = [NSDate date];
    self.highlighted = YES;
    if (self.recording) {
        [self setStartRecordStatus];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highlighted = NO;
    if (self.recording) {
        [self setFinishRecordStatus];
    }
    else{
        BOOL isSelectingAction = [[NSDate date] compare:[NSDate dateWithTimeInterval:1.f sinceDate:startTime]] == NSOrderedAscending;
        if (!isSelectingAction || self.selected) {
            return;
        }
        self.selected = YES;
        [self startPlayAnimation];
        if ([_delegate respondsToSelector:@selector(recorderButtonDidStarted)]) {
            [_delegate recorderButtonDidStarted];
        }
//        else{
//            [self stopPlayAnimation];
//            if ([_delegate respondsToSelector:@selector(recorderButtonDidFinished)]) {
//                [_delegate recorderButtonDidFinished];
//            }
//        }
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Audio Button Cancelled");
}

@end