//
//  SettingRemove.m
//  MorningCall
//
//  Created by Tian Tian on 2/17/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingRemove.h"
#import "SettingRemoveCell.h"

@interface SettingRemove ()

@end

@implementation SettingRemove

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Remove";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRemoveTable:)];
}

- (void)refreshRemoveTable:(id)sender{
    NSLog(@"refresh remove table");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingRemoveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingRemoveCell" forIndexPath:indexPath];
    
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self action:@selector(removeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)removeButtonSelected:(UIButton *)sender{
    [sender setBackgroundColor:[UIColor clearColor]];
    sender.enabled = NO;
}
@end
