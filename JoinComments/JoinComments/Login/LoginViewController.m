//
//  LoginViewController.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "LoginViewController.h"
#import <UIKit/UIKit.h>
#import "CommentDataManager.h"
#import "CommentDataManager+DataEngine.h"
#import "CommentDataTool.h"
#import "RegisterViewController.h"
#import "NotificationKeys.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickLoginButton:(id)sender {
    if([self checkUserInpufIfRight]) {
        [self loginWithName:self.nameTF.text andPassword:self.pwdTF.text];
    }
    
}
- (IBAction)clickRegisterButton:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController * ctr = [sb instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (BOOL)checkUserInpufIfRight {
    NSString * name = self.nameTF.text;
    NSString * pwd = self.pwdTF.text;
    if (!name || [name length] < 1) {
        [self showTextToast:@"请输入用户名"];
        return false;
    }
    if (!pwd || [pwd length] < 1) {
        [self showTextToast:@"请输入密码"];
        return false;
    }
    return true;
}

#pragma mark - network

- (void)loginWithName:(NSString *)name andPassword:(NSString *)pwd {
    NSDictionary * headers = nil;
    NSString * password = [CommentDataTool md5:[NSString stringWithFormat:@"Comment_Demo_Client%@",pwd]];
    NSDictionary * params = @{
        @"username":name,
        @"password":password
    };
    CommentLoginAPIConfig * config = [[CommentLoginAPIConfig alloc] initWithRequestType:CommentRequestTypePostJson parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
                NSString * user_id = [data objectForKey:@"user_id"];
                NSString * token = [data objectForKey:@"token"];
                [CommentDataManager shareCommentDataManager].user_id = user_id;
                [CommentDataManager shareCommentDataManager].token = token;
                if ([CommentDataManager shareCommentDataManager].enterCtrl == nil) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccess object:nil];
                    }];
                }else {
//                    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
//                    keyWindow.rootViewController = [CommentDataManager shareCommentDataManager].enterCtrl;
//                    [keyWindow makeKeyAndVisible];
//                    [CommentDataManager shareCommentDataManager].enterCtrl = nil;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccess object:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccess object:nil];
                    }];
                }
                
            }else {
                [self showTextToast:msg];
            }
            NSLog(@"msg = %@", msg);
            
        }
    } failBlock:^(NSError * _Nullable error) {
        [self showTextToast:@"网络异常请稍后再试"];
    }];
}
@end
