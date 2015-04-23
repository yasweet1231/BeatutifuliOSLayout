
//
//  SettingTwitterAccount.m
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingTwitterAccount.h"

@interface SettingTwitterAccount ()

@end

@implementation SettingTwitterAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter Acount";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Link Twitter");
}

@end
