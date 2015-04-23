//
//  SettingAbout.m
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingAbout.h"
#import <MessageUI/MessageUI.h>
@interface SettingAbout () <MFMailComposeViewControllerDelegate>

@end

@implementation SettingAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *str = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=";
        str = [NSString stringWithFormat:@"%@%@",str,APPLE_APP_ID];
//        @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
//        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
//        str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
        
        // Here is the app id from itunesconnect
//        str = [NSString stringWithFormat:@"%@861265124", str];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if (indexPath.row == 1){

        if(![MFMailComposeViewController canSendMail]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support sending mail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"origami@goexcite.today"]];
        [controller setSubject:[NSString stringWithFormat:@"\"APP Morning Call\" Feedback"]];
        [controller setMessageBody:@"\n\n Please help us to improve Morning Call!" isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Sending Mail Successed!");
    }else{
        NSLog(@"Sending Mail Failed!");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
