//
//  SingleItemInputView.h
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleItemInputView : UIViewController

@property (nonatomic, strong) id parentInputArea;
@property (nonatomic, strong) NSString *placeholder;

@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIButton *deleteInputContentButton;

- (IBAction)cancelInput:(id)sender;
- (IBAction)saveInput:(id)sender;

@end
