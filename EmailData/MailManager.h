//
//  MailManager.h
//  MyBookshelf
//
//  Created by mac on 2017/2/9.
//  Copyright © 2017年 chc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface MailManager : NSObject<MFMailComposeViewControllerDelegate>
- (void)lanchMailWithDataPath:(NSString *)path;
+ (id)defaultManager;
@property (nonatomic, assign)id<MFMailComposeViewControllerDelegate>mailDelegate;
@end
