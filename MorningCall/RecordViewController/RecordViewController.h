//
//  RecordViewController.h
//  MorningCall
//
//  Created by Tian Tian on 2/18/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum _RecordButtonType {
//    RecordType = 0,
//    PlayType,
//} RecordButtonType;

static const    NSTimeInterval  MaxRecordingTime = 30.f;

@protocol RecorderButtonDelegate <NSObject>
- (void)recorderButtonDidStarted;
- (void)recorderButtonDidFinished;
@end

@interface RecordButton : UIButton

@property (nonatomic, assign) BOOL  recording;
@property (weak, nonatomic) id<RecorderButtonDelegate> delegate;
@property (retain, nonatomic) UILabel   *statusTitle;

@property (nonatomic, readonly) NSTimeInterval  recordedDuring;
@end



@interface RecordViewController : UIViewController <UIViewControllerAnimatedTransitioning,RecorderButtonDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet RecordButton *recordButton;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;



@end


