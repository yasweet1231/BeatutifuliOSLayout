//
//  SettingRequest.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingRequest.h"
#import "SettingRequestCell.h"

@interface SettingRequest ()

@end

@implementation SettingRequest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Requests";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(regreshRequestTable:)];
}

- (void)regreshRequestTable:(id)sender{
    NSLog(@"refresh request table.");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingRequestCell" forIndexPath:indexPath];
    
    cell.acceptButton.tag = indexPath.row;
    [cell.acceptButton addTarget:self action:@selector(acceptButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)acceptButtonSelected:(UIButton *)sender{
    [sender setBackgroundColor:[UIColor clearColor]];
    sender.enabled = NO;
}

@end
