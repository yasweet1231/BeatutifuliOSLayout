//
//  SearchFrindViewController.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SearchFrindViewController.h"

#import "LayoutExtension.h"
#import "ConfirmItemInputView.h"

@interface SearchFrindViewController ()
@end

@implementation SearchFrindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Friends";
    
    self.navigationController.navigationBar.tintColor = self.mc_HighlightedGreen;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
    
    _searchByIDEmailButton.clipsToBounds = YES;
    _searchByIDEmailButton.layer.cornerRadius = 8.f;
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text rangeOfString:@"Invitation"].length>0) {
        ConfirmItemInputView *confirmInvitation;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            confirmInvitation = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmItemInputView"];
        }else{
            confirmInvitation = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmItemInputView"];
        }
        confirmInvitation.confirmTitle = @"Please Enter Your Invitation Number :";
        confirmInvitation.inputPlaceHolder = @"invitation number";
        [self.navigationController pushViewController:confirmInvitation animated:YES];
    }
}

@end
