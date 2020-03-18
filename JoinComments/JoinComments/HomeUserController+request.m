//
//  HomeUserController+request.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/16.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeUserController+request.h"
#import <UIKit/UIKit.h>
#import "CommentDataManager.h"
#import "CommentDataManager+DataEngine.h"
#import "UIViewController+Toast.h"
#import <SDWebImage/SDWebImage.h>

@implementation HomeUserController (request)

- (void)loadUserDetailData:(NSString *)userId {
    NSString * user_id = userId;
    if (!user_id || [user_id length] < 1) {
        return;
    }
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"user_id":user_id,
    };
    CommentUserDetailAPIConfig * config = [[CommentUserDetailAPIConfig alloc] initWithRequestType:CommentRequestTypeGet parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
               //成功
                NSString * name = [data objectForKey:@"username"];
                NSString * avatar = [data objectForKey:@"avatar"];
                self.nameLabel.text = name;
                if (avatar && [avatar isKindOfClass:[NSString class]] && [avatar length] > 0) {
                    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageRetryFailed];
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

- (void)logoutRequestCompletion: (void (^ __nullable)(void))completion{
    
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        return;
    }
    NSString * user_id = [CommentDataManager shareCommentDataManager].user_id;
    if (!user_id || [user_id length] < 1) {
        return;
    }
    
    NSDictionary * headers = @{@"x-comment-demo-token":token};
//    NSDictionary * params = @{@"user_id":user_id};
    NSDictionary * params = @{@"":@""};
    CommentLogoutAPIConfig * config = [[CommentLogoutAPIConfig alloc] initWithRequestType:CommentRequestTypePostJson parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
               //成功
                [self closeUserControllerAnimated:YES completion:completion];
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
