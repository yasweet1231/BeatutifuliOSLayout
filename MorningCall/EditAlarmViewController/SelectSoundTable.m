//
//  SelectSoundTable.m
//  MorningCall
//
//  Created by Tian Tian on 2/14/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SelectSoundTable.h"
#import <AVFoundation/AVFoundation.h>

#import "EditAlarmTable.h"
#import "Brain.h"
#import "LayoutExtension.h"

@interface SelectSoundTable () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer     *soundPlayer;
@property (nonatomic, strong) EditAlarmTable    *parentEditAT;

@property (nonatomic, strong) NSString          *playingSoundName;
@end

@implementation SelectSoundTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Default Sounds";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Default" style:UIBarButtonItemStylePlain target:self action:@selector(setCurrentSoundToDefault:)];
    
    UIViewController *previousView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    if ([previousView isKindOfClass:[EditAlarmTable class]]){
        _parentEditAT = (EditAlarmTable *)previousView;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    _playingSoundName = _parentEditAT.soundNameLabel.text;
    [self.tableView reloadData];
}

//- (EditAlarmTable *)parentEditAT{
//    if (!_parentEditAT) {
//        UIViewController *previousView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
//        if ([previousView isKindOfClass:[EditAlarmTable class]]){
//            _parentEditAT = (EditAlarmTable *)previousView;
//        }else{
//            previousView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//            if ([previousView isKindOfClass:[EditAlarmTable class]]){
//                _parentEditAT = (EditAlarmTable *)previousView;
//            }
//        }
//    }
//    return _parentEditAT;
//}

- (void)setCurrentSoundToDefault:(id)sender{
    if (_playingSoundName.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:_playingSoundName forKey:KEY_DEFAULT_ALARM_SOUND_NAME];
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.parentEditAT) {
        self.parentEditAT.soundNameLabel.text = _playingSoundName;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self mc_DefaultAlarmSoundsRelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mc_DefaultAlarmSounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultAlarmSoundTableCell" forIndexPath:indexPath];
    NSString *displayName = [self.mc_DefaultAlarmSounds displayNameWithIndex:indexPath.row];
    BOOL isDefaultSound = [displayName isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_DEFAULT_ALARM_SOUND_NAME]];
    cell.textLabel.text = isDefaultSound?[displayName stringByAppendingString:@" (Default)"] : displayName;
    cell.textLabel.textColor = isDefaultSound ? self.mc_Orange : self.mc_LightGreen;
    BOOL isPlayingSound = [displayName isEqualToString:_playingSoundName];
    cell.accessoryType = isPlayingSound ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"row selected %ld",(long)indexPath.row);
    _playingSoundName = [self.mc_DefaultAlarmSounds displayNameWithIndex:indexPath.row];
    [self.tableView reloadData];
    [self playSoundWitSoundName:_playingSoundName];
}

- (void)playSoundWitSoundName:(NSString *)soundName{
    if (_soundPlayer && _soundPlayer.isPlaying) {
        [_soundPlayer stop];
    }
    
    _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self filePathWithFileName:soundName] error:nil];
    _soundPlayer.delegate = self;
    [_soundPlayer prepareToPlay];
    
    while (_soundPlayer.prepareToPlay) {
        [_soundPlayer play];
        break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        _soundPlayer = nil;
    }
}

- (NSURL *)filePathWithFileName:(NSString *)fileName{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"]];
}

@end
