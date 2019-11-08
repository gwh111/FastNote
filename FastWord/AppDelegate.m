//
//  AppDelegate.m
//  FastWord
//
//  Created by gwh on 2019/11/4.
//  Copyright 2019 gwh. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)load {
    [ccs registerAppDelegate:self];
}

- (void)cc_willInit {
    
    [self cc_initViewController:HomeViewController.class withNavigationBarHidden:NO block:^{
        CCLOG(@"path=%@",NSHomeDirectory());
    }];
}

- (BOOL)cc_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)cc_applicationWillResignActive:(UIApplication *)application {

}

- (void)cc_applicationDidEnterBackground:(UIApplication *)application {

}

- (void)cc_applicationWillEnterForeground:(UIApplication *)application {

}

- (void)cc_applicationDidBecomeActive:(UIApplication *)application {

}

- (void)cc_applicationWillTerminate:(UIApplication *)application {

}

@end
