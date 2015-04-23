//
//  ConfirmItemInputView.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "ConfirmItemInputView.h"

@interface ConfirmItemInputView () <UITextFieldDelegate>

@end

@implementation ConfirmItemInputView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSelf:)];
    
    _okButton.layer.cornerRadius = _okButton.bounds.size.width/2;
    _okButton.clipsToBounds = YES;
    [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _processingView.hidden = YES;
    
    _titleLabel.text = _confirmTitle;
    _inputField.placeholder = _inputPlaceHolder;
    _inputField.text = _inputContent;
}

- (void)dismissSelf:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)okButtonPressed:(UIButton *)sender{
    _processingView.frame = CGRectMake(0, 0, _processingView.frame.size.width, _processingView.frame.size.height);
    [_activityIndic startAnimating];
    _processingView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end
