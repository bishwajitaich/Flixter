//
//  AppDelegate.m
//  Flixter
//
//  Created by Bishwajit Aich. on 1/23/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieViewController.h"
#import "DVDViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Set the status bar to white color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    MovieViewController *mvc = [[MovieViewController alloc] init];
    UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    UIImage* movieImage = [UIImage imageNamed:@"movie.png"];
    UITabBarItem* movieItem = [[UITabBarItem alloc] initWithTitle:@"Movies" image:movieImage tag:0];
    mnvc.tabBarItem = movieItem;

    DVDViewController *dvc = [[DVDViewController alloc] init];
    UINavigationController *dnvc = [[UINavigationController alloc] initWithRootViewController:dvc];
    UIImage* dvdImage = [UIImage imageNamed:@"dvd.png"];
    UITabBarItem* dvdItem = [[UITabBarItem alloc] initWithTitle:@"DVDs" image:dvdImage tag:0];
    dnvc.tabBarItem = dvdItem;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray* controllers = [NSArray arrayWithObjects:mnvc, dnvc, nil];
    tabBarController.viewControllers = controllers;
    
    tabBarController.tabBar.tintColor = [UIColor yellowColor];
    tabBarController.tabBar.barTintColor = [UIColor blackColor];
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
