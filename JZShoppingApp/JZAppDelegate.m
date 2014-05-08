//
//  JZAppDelegate.m
//  JZShoppingApp
//
//  Created by jihong zhang on 4/29/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "JZAppDelegate.h"
#import "JZWelcomeViewController.h"

@implementation JZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    JZWelcomeViewController *rootViewController = [[JZWelcomeViewController alloc] init];
    rootViewController.title = @"Jihong Home";
    
    //navigationBar
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    
    self.window.rootViewController = navigation;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
