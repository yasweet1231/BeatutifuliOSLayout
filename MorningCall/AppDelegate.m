//
//  AppDelegate.m
//  MorningCall
//
//  Created by Tian Tian on 2/12/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "AppDelegate.h"
#import "Brain.h"
#import "ALarmOnViewController.h"
#import "MCSystemNotificationAlert.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSLog(@"UUIDs : %@",[UIDevice currentDevice].identifierForVendor);
    
//    UIViewController *firstViewController;
//    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (localNotif) {  // @"show alarm on"
//    }else{  // @"show main view controller"
//    }
    
    [self registerNotifications];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Me initiate];
    return YES;
}

#pragma - MARK
#pragma - Notifications

- (void)registerNotifications{
//    UIMutableUserNotificationAction* deleteAction = [[UIMutableUserNotificationAction alloc] init];
//    [deleteAction setIdentifier:@"delete_action_id"];
//    [deleteAction setTitle:@"Delete"];
//    [deleteAction setActivationMode:UIUserNotificationActivationModeBackground];
//    [deleteAction setDestructive:YES];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    UIMutableUserNotificationAction* replyAction = [[UIMutableUserNotificationAction alloc] init];
    [replyAction setIdentifier:@"play_action_id"];
    [replyAction setTitle:@"Play"];
    [replyAction setActivationMode:UIUserNotificationActivationModeBackground];
    [replyAction setDestructive:NO];
    
    UIMutableUserNotificationCategory* playCategory = [[UIMutableUserNotificationCategory alloc] init];
    [playCategory setIdentifier:@"custom_category_id"];
    [playCategory setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet* categories = [NSSet setWithArray:@[playCategory]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:categories]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
}

#pragma - Local Notifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Did received notification:%@ \n should present AlarmOnView",notification);
    NSString *alarmId = [NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"uid"]];
    
//    UIApplicationState applicationState = application.applicationState;
//    if (applicationState != UIApplicationStateActive) {
//        [application presentLocalNotificationNow:notification];
//    }
    
    ALarmOnViewController *alarmOn;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        alarmOn = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ALarmOnViewController"];
    }else{
        alarmOn = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ALarmOnViewController"];
    }
//    UIWindow *newWin = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIViewController *new = [UIViewController new];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:alarmOn];
//    navi.navigationBarHidden = YES;
//    [newWin addSubview:alarmOn.view];
//    [newWin makeKeyAndVisible];
    
    if ([self.window.rootViewController presentedViewController]!=nil) {
        [self.window.rootViewController.presentedViewController presentViewController:alarmOn animated:YES completion:nil];
    }else{
        [self.window.rootViewController presentViewController:alarmOn animated:YES completion:nil];
    }
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler{
    if([notification.category isEqualToString:@"custom_category_id"]){
        if([identifier isEqualToString:@"play_action_id"]){
            NSLog(@"Try to Play Audio");
        }
    }
    completionHandler();
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"current notification setting : %u",notificationSettings.types);
//    NSLog(@"current notification categories : %@",notificationSettings.categories);
    if ([UIApplication sharedApplication].currentUserNotificationSettings.types != (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your Alarm may not work properly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma Remote Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSString *theDeviceToken = [[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![Me alive].privateInfo.deviceToken.length>0) {
        NSLog(@"update and register remoteNotification");
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Morning Call\" Would Like to Send You Push Notifications" message:@"Notification may include alerts, sounds and icon badges. These can be configured in Settings.\n It will unable to receive audios from friends if you reject this request." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"Allow", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Allow"]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@", userInfo]);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    id aps = [userInfo valueForKey:@"aps"];
    if ([aps isKindOfClass:[NSDictionary class]]) {
        SystemNotification *showSN = [[SystemNotification alloc] init];
        showSN.systemNotificationId = [aps valueForKey:@"messageId"];
        showSN.systemNotificationType = (SystemNotificationType)((NSString *)[aps valueForKey:@"systemNotificationType"]).integerValue;
        showSN.content = [aps valueForKey:@"content"];
        showSN.fromId = [aps valueForKey:@"fromId"];
        
        MCSystemNotificationAlert *alertView = [[MCSystemNotificationAlert alloc] initWithSystemNotification:showSN];
        [alertView show];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ilove-fashionapp.core" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MorningCall" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MorningCall.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
