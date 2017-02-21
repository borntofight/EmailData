
## intro(介绍)
    你的app中可能有部分重要的用户数据需要进行备份,备份的方式可能有多种,如云端,但用户担心云端备份可能泄露自己的隐私,而且云端给人的感觉可能不是太可靠.由于iOS系统的封闭性,以及对用户数据的严密保护,所以目前想到的可用方法就是同过邮件进行备份,这样用户也能对备份过程有所掌控,较少担忧.
    大概流程是:
```markdown
1. 用户点击备份,将本地数据通过SSZipArchive打包为zip;
2. 将zip文件通过邮件发送出去;
3. 用户需要恢复备份时,通过系统应用Mail打开备份文件,通过长按附件zip,打开Mail的activity,选择其中的"copy to EmailData";
4. 这时Mail会拉起demo App;
5. 通过处理AppDelegate的回调来对copy到demo的数据进行unzip处理,完成备份恢复;

```

## important(关键)
    在infor.plist中设置应用的Document types和Exported Type UTIs,具体参见infor.plist.通过设置,才能使Mail对长按".zip"格式的附件打开的activity中拉起demo,从而完成数据拷贝传输;<br>
    
```Objective-C
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>CFBundleTypeExtensions</key>
		<array>
			<string>zip</string>
		</array>
		<key>CFBundleTypeName</key>
		<string>email data</string>
		<key>LSItemContentTypes</key>
		<array>
			<string>cn.dot99.EmailData</string>
		</array>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>LSHandlerRank</key>
		<string>Owner</string>
	</dict>
</array>
</plist>

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>UTTypeIdentifier</key>
		<string>cn.dot99.EmailData</string>
		<key>UTTypeConformsTo</key>
		<array>
			<string>cn.dot99.EmailData</string>
		</array>
		<key>UTTypeDescription</key>
		<string>MyMoney Backup</string>
		<key>UTTypeTagSpecification</key>
		<dict>
			<key>public.mime-type</key>
			<string>application/cn.dot99.EmailData</string>
			<key>public.filename-extension</key>
			<string>zip</string>
		</dict>
	</dict>
</array>
</plist>
```

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

```Objective-C
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
![Image](https://github.com/borntofight/EmailData/edit/master/imgs/1.jpg)


