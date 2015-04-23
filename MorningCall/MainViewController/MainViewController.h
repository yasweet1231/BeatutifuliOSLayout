//
//  MainViewController.h
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewBotListView.h"
#import "ALarmOnViewController.h"
#import "Brain.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *alarmListTable;
@property (strong, nonatomic) IBOutlet UIButton *addNewAlarmButton;

@property (strong, nonatomic) IBOutlet MainViewBotListView *botUserListView;

@property (strong, nonatomic) IBOutlet UIView *weatherPanel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *tempHighLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempLowLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
//- (void)refreshWeatherPanelWithWeather:(Weather *)weather;

- (IBAction)testFunction:(id)sender;

@end


