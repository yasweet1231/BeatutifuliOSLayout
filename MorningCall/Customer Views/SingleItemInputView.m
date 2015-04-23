//
//  SingleItemInputView.m
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SingleItemInputView.h"
#import "LayoutExtension.h"
@interface SingleItemInputView () <UITextFieldDelegate>

@end

@implementation SingleItemInputView

- (void)awakeFromNib{
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInput:)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInput:)];
    self.navigationController.navigationBar.tintColor = self.mc_BackgroundGreen;
    
    [_deleteInputContentButton addTarget:self action:@selector(deleteInputContent:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteInputContentButton.layer setMasksToBounds:YES];
    _deleteInputContentButton.layer.cornerRadius = _deleteInputContentButton.bounds.size.width/2;
    _deleteInputContentButton.layer.borderWidth = 1.f;
    _deleteInputContentButton.layer.borderColor = self.mc_LightGreen.CGColor;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([_parentInputArea isKindOfClass:[UILabel class]]) {
        UILabel *parent = (UILabel *)_parentInputArea;
        _inputField.text = parent.text;
        _inputField.placeholder = _placeholder;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_inputField becomeFirstResponder];
}

- (void)deleteInputContent:(UIButton *)sender{
    _inputField.text = @"";
}

- (IBAction)cancelInput:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveInput:(id)sender {
    if ([_parentInputArea isKindOfClass:[UILabel class]]) {
        ((UILabel *)_parentInputArea).text = _inputField.text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - MARK
#pragma - Text filed

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    return [textField becomeFirstResponder];
//}

@end
