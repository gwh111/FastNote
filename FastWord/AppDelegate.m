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
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[path lastObject] stringByAppendingPathComponent:@"FastWord_v1.sqlite"];

    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open]) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
    if (![db columnExists:@"height" inTableWithName:@"NotesSummary"]){
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"NotesSummary",@"height"];
        BOOL worked = [db executeUpdate:alertStr];
        if(worked){
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
    if (![db columnExists:@"height" inTableWithName:@"NotesContent"]){
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"NotesContent",@"height"];
        BOOL worked = [db executeUpdate:alertStr];
        if(worked){
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
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

    if (Data.shared.kouzhaoCountStart) {
        Data.shared.kouzhaoCount++;
        if (Data.shared.kouzhaoCount >= 3) {
            Data.shared.kouzhaoCount = 0;
        }
        
        NSString *text = Data.shared.kouzhaoTexts[Data.shared.kouzhaoCount];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [ccs showNotice:[ccs string:@"已复制：%@",text]];
    }
}

- (void)cc_applicationDidBecomeActive:(UIApplication *)application {

}

- (void)cc_applicationWillTerminate:(UIApplication *)application {

}

@end
