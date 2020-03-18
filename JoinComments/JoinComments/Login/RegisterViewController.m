//
//  RegisterViewController.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "RegisterViewController.h"
#import <UIKit/UIKit.h>
#import "CommentDataManager.h"
#import "CommentDataManager+DataEngine.h"
#import "CommentDataTool.h"
#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTF.text = @"xuanyuanhongxing";
    self.pwdTF.text = @"hongxing2020";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickRegisterButton:(id)sender {
    if([self checkUserInpufIfRight]) {
        [self registerWithName:self.nameTF.text andPassword:self.pwdTF.text];
    }
}
- (IBAction)clickLoginButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)registerWithName:(NSString *)name andPassword:(NSString *)pwd {
    NSDictionary * headers = nil;
    NSString * password = [CommentDataTool md5:[NSString stringWithFormat:@"Comment_Demo_Client%@",pwd]];
    NSDictionary * params = @{
        @"username":name,
        @"password":password
    };
    CommentRegisterAPIConfig * config = [[CommentRegisterAPIConfig alloc] initWithRequestType:CommentRequestTypePostJson parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
                NSString * idName = [data objectForKey:@"idName"];
                NSLog(@"idname=%@",idName);
                [self.navigationController popViewControllerAnimated:YES];
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
