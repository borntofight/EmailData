//
//  AppDelegate.m
//  EmailData
//
//  Created by mac on 2017/2/2.
//  Copyright © 2017年 chc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self initFiles];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    FileListTableViewController *fileListTableViewController = [[FileListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    fileListTableViewController.title = @"files";
    PerfomingViewController *performingViewController = [[PerfomingViewController alloc] init];
    performingViewController.title = @"performing";
    
    self.tabBarController.viewControllers = @[fileListTableViewController, performingViewController];
    self.window.rootViewController = self.tabBarController;
    
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//tap activity's "copy to maildata",will launch maildata,get data here
//    file:///private/var/mobile/Containers/Data/Application/5C611935-23F6-4947-B44F-AFDF30440D34/Documents/Inbox/2017%E5%B9%B42%E6%9C%882%E6%97%A5%20%E6%98%9F%E6%9C%9F%E5%9B%9B-3.zip
    
    
    if([url.absoluteString containsString:@"zip"]){//注意多次发送邮件，备份文件名可能发生的变化
        [[NSData dataWithContentsOfURL:url] writeToFile:ZIP_FILE_PATH atomically:YES];
        
        [SSZipArchive unzipFileAtPath:ZIP_FILE_PATH toDestination:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            //
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            //
            if (succeeded) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"congratulations" message:@"recover successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                for (UIViewController *viewController in self.tabBarController.viewControllers) {
                    if ([viewController isKindOfClass:[FileListTableViewController class]]) {
                        [((FileListTableViewController *)viewController) getCurrentFiles];
                    }
                }
            }
            
        }];
        return YES;
    }else{
        return YES;
    }
}


#pragma mark -

- (void)initFiles{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:ZIP_DIR withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createDirectoryAtPath:FILE_DIR withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *fileNames = @[@"0", @"1", @"2", @"3"];
    for (NSString *name in fileNames) {
        NSString *originalPath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
        NSString *targetPath = [FILE_DIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",name]];
        [manager copyItemAtPath:originalPath toPath:targetPath error:nil];
    }
    
}

@end
