//
//  CZAppDelegate.m
//  CZWeatherKit Example iOS
//
//  Created by Comyar Zaheri on 5/25/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZAppDelegate.h"
#import "CZMainViewController.h"


#pragma mark - CZAppDelegate Implementation

@implementation CZAppDelegate
@synthesize window = _window;

#pragma mark UIApplicationDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [CZMainViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
