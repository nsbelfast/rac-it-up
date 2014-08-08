//
//  RMBAppDelegate.m
//  RACItUp
//
//  Created by Iain Wilson on 07/08/2014.
//  Copyright (c) 2014 Rumble Labs. All rights reserved.
//

#import "RMBAppDelegate.h"

#import "RMBPromptViewController.h"

@implementation RMBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RMBPromptViewController new]];
  [self.window makeKeyAndVisible];

  return YES;
}

@end
