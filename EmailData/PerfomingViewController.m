//
//  NewBackupViewController.m
//  MyBookshelf
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 曹贺春. All rights reserved.
//

#import "PerfomingViewController.h"
#import <SSZipArchive/SSZipArchive.h>
#import "MailManager.h"
@interface PerfomingViewController ()
{

    UIButton *backupButton;
    UIButton *recoverButton;


}
@end

@implementation PerfomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    backupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backupButton setBackgroundColor:[UIColor redColor]];
    [backupButton setTitle:@"backup" forState: UIControlStateNormal];
    [backupButton addTarget:self action:@selector(fullBackup) forControlEvents:UIControlEventTouchUpInside];
    backupButton.layer.cornerRadius = 5;
    [self.view addSubview:backupButton];
    
    recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverButton setBackgroundColor:[UIColor redColor]];
    [recoverButton setTitle:@"recover" forState: UIControlStateNormal];
    recoverButton.layer.cornerRadius = 5;
    [recoverButton addTarget:self action:@selector(fullRecover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverButton];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)dealloc{

}
- (void)viewWillLayoutSubviews{
#define boarder 20
#define button_height 40
    
    backupButton.frame = CGRectMake(boarder, 100, MAINSCREEN_WIDTH - 2*boarder, button_height);
    recoverButton.frame = CGRectMake(backupButton.frame.origin.x, backupButton.frame.origin.y + backupButton.frame.size.height + boarder, backupButton.frame.size.width, button_height);
    
}

#pragma mark - 完全备份
- (void)fullBackup{
    

    [self cleartempZipBeforeBackup];
  
    [SSZipArchive createZipFileAtPath:ZIP_FILE_PATH withContentsOfDirectory:FILE_DIR keepParentDirectory:YES withPassword:nil andProgressHandler:^(NSUInteger entryNumber, NSUInteger total) {
        if (entryNumber == total) {
            NSData *data = [NSData dataWithContentsOfFile:ZIP_FILE_PATH];
            
            NSString *message = [NSString stringWithFormat:@"zip size:%.1f KB,send?",[data length]/1024.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"zip ready" message:message delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"send", nil];
            [alert show];
        }

        
    }];
}
- (void)fullRecover{
    

    if (![[NSFileManager defaultManager] fileExistsAtPath:ZIP_FILE_PATH]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no backup file found" message:@"please backup first then copy file from email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [SSZipArchive unzipFileAtPath:ZIP_FILE_PATH toDestination:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        //
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        //

    }];
}
- (void)clearTempZipAfterLaunchMail{
    [[NSFileManager defaultManager] removeItemAtPath:ZIP_FILE_PATH error:nil];
}
- (void)cleartempZipBeforeBackup{
    [[NSFileManager defaultManager] removeItemAtPath:ZIP_FILE_PATH error:nil];
}

- (void)lanchMail{
    [[MailManager defaultManager] setMailDelegate:self];
    [[MailManager defaultManager] lanchMailWithDataPath:ZIP_FILE_PATH];
    [self clearTempZipAfterLaunchMail];

}
#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self lanchMail];
    }
}
#pragma mark - mail delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    NSString *alertMessage;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alertMessage = @"email canceled";
            break;
        case MFMailComposeResultSaved:
            alertMessage = @"email saved";
            break;
        case MFMailComposeResultSent:
            alertMessage = @"email send";
            break;
        case MFMailComposeResultFailed:
            alertMessage = @"email failed";
            break;
        default:
            alertMessage = @"email error";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"mail operation result:" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
