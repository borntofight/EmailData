

### how to use the demo


```markdown
1. launch app,there will be four jpg copied to file dir,you will see in the list Tab; 
2. tap the performing Tab,tap Backup button,current jpg files will be ziped and send a mail; 
3. tap the list Tab,delete one or more cell, the jpg files also be deleted; 
4. Use Mail app to open the backup mail,long press the zip attatchment,choose “copy to EmailData”;
5. Mail will launch the EmailData demo app,the backup zip file will be unzipped, and the jpg files will be recovered;
6. in the list Tab,you will see the entire four jpg files;

```
### code clip
```markdown


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


```

### images
![Image](https://www.manshushe.com/user/images/18510012189.jpg)


