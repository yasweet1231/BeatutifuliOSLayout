//
//  PhoneNumberTable.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "PhoneNumberTable.h"
#import "Person.h"
#import "Brain.h"

@interface PhoneNumberTable () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSArray   *phoneNumberList;
@property (nonatomic, strong) Person    *selectedPerson;
@property (nonatomic, assign) BOOL    isEasten;
@end

@implementation PhoneNumberTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *contactList = [self getContactList];
    [self pickupItemsToPhoneNumberList:contactList];
    
    _isEasten =
    [[Me alive].privateInfo.country isEqualToString:@"Japan"] ||
    [[Me alive].privateInfo.country isEqualToString:@"China"] ||
    [[Me alive].privateInfo.country isEqualToString:@"Korean"];
}

- (NSArray *)getContactList{
    ABAddressBookRef addressBook;
    
    __block BOOL userDidGrantAddressBookAccess;
    CFErrorRef addressBookError = NULL;
    
    if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized )
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, &addressBookError);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            userDidGrantAddressBookAccess = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted )
        {
            // Display an error.
            NSLog(@"Denied");
        }
    }
    
    NSMutableArray *tempContactArray = [[NSMutableArray alloc]init];
    
    //    CFErrorRef error = NULL;
    //    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (addressBook!=nil)
    {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            Person *person = [[Person alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            
            person.firstName = firstName!=nil ? firstName : @"";
            person.lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            //            person.emails =  (__bridge_transfer NSArray*)ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            // get email
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phoneNumbers)>0) {
                person.phoneNumbers = [[NSMutableArray alloc] init];
                for (CFIndex j=0; j < ABMultiValueGetCount(phoneNumbers); j++) {
                    NSString* email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, j);
                    [person.phoneNumbers addObject:email];
                }
            }
            
            // get phone number
            
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            if (ABMultiValueGetCount(emails)>0) {
                person.mails = [[NSMutableArray alloc] init];
                for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
                    NSString* email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                    [person.mails addObject:email];
                }
            }
            [tempContactArray addObject:person];
        }
        CFRelease(addressBook);
        return (NSArray *)tempContactArray;
    }
    else
    {
        NSLog(@"Error");
    }
    return nil;
}

- (void)pickupItemsToPhoneNumberList:(NSArray *)contactList{
    NSMutableArray *tempPArray = [[NSMutableArray alloc] init];
    for (Person *aPer in contactList) {
        if (!aPer.phoneNumbers.count>0) continue;
        
        for (NSString *aPhone in aPer.phoneNumbers) {
            if (aPhone.length>1) {
                Person *addPer = [[Person alloc] init];
                addPer.firstName = aPer.firstName!=nil ? aPer.firstName : @"";
                addPer.lastName = aPer.lastName!=nil ? aPer.lastName : @"";
                addPer.anItem = aPhone;
                [tempPArray addObject:addPer];
            }
        }
    }
    _phoneNumberList = (NSArray *)tempPArray;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _phoneNumberList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneNumberTableCell" forIndexPath:indexPath];
    
    Person *aPer = [_phoneNumberList objectAtIndex:indexPath.row];
    cell.textLabel.text = self.isEasten ? [NSString stringWithFormat:@"%@ %@",aPer.lastName,aPer.firstName]:[NSString stringWithFormat:@"%@ %@",aPer.firstName,aPer.lastName];
    cell.detailTextLabel.text = aPer.anItem;
    
    UIButton *sendSMSButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    sendSMSButton.center = CGPointMake(cell.frame.size.width-sendSMSButton.bounds.size.width/2, cell.frame.size.height/2);
    [sendSMSButton setBackgroundImage:[UIImage imageNamed:@"Theme1_iconSendMail.png"] forState:UIControlStateNormal];
    sendSMSButton.tag = indexPath.row;
    [sendSMSButton addTarget:self action:@selector(sendSMSButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = sendSMSButton;
    
    return cell;
}

- (void)sendSMSButtonPressed:(UIButton *)sender{
    Person *thePer = [_phoneNumberList objectAtIndex:sender.tag];
    [self sendSMStoPhoneNumber:thePer.anItem];
}

- (void)sendSMStoPhoneNumber:(NSString *)phoneNumber{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your device does not support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:
                         @"Let's try sharing our Morning Alarms. \nYou can download the APP from \"https://itunes.apple.com/us/app/social-alarm-clock-make-you/id861265124?ls=1&mt=8\" \n Use the Invitation ID and verification code when you at the beginning. \n Verification Code: \"%@\" \n Expiration Date: \"%@\"",self.mc_GenerateRamdomString,[[NSDate date] mc_LocalMMDDString]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:@[phoneNumber]];
    [messageController setBody:message];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                   message:@"Failed to Send SMS. \nPlease try later."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                   message:@"Your friend has been invited."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
