//
//  MailManager.m
//  MyBookshelf
//
//  Created by mac on 2017/2/9.
//  Copyright © 2017年 chc. All rights reserved.
//

#import "MailManager.h"
#import "AppDelegate.h"
@implementation MailManager
+ (id)defaultManager{
    static MailManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[MailManager alloc] init];
    });
    return manager;
}

- (void)lanchMailWithDataPath:(NSString *)path{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    //判断是否绑定邮箱
    if (!picker) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"notice" message:@"please check your email account" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    picker.mailComposeDelegate = self.mailDelegate;
    [picker setSubject:@"email data test"];
    
    NSData *myData;
    NSString *emailBody;
    
    myData = [NSData dataWithContentsOfFile:path];
    //附件内容,显示类型,显示名称
    NSString *attachmentName = [[path componentsSeparatedByString:@"/"] lastObject];
    NSString *type = [[attachmentName componentsSeparatedByString:@"."] lastObject];
    [picker addAttachmentData:myData mimeType:type fileName:attachmentName];
    
    emailBody = [NSString stringWithFormat:@"When recover,long press the zip attachment,choose copy to EmailData!"];
    
    [picker setMessageBody:emailBody isHTML:NO];
    UIViewController *viewController = (UIViewController *)self.mailDelegate;
    [viewController presentViewController:picker animated:YES completion:nil];
}



@end
