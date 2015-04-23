//
//  ConfirmItemInputView.h
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmItemInputView : UIViewController

// Output
@property (nonatomic, strong) id parentInputArea;

// Input
@property (strong, nonatomic) NSString  *confirmTitle;
@property (strong, nonatomic) NSString  *inputPlaceHolder;
@property (strong, nonatomic) NSString  *inputContent;

// Private
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) IBOutlet UIView *processingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;

@end
