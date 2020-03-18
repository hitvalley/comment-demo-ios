//
//  HomeTopicDetailController+request.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeTopicDetailController+request.h"
#import <UIKit/UIKit.h>
#import "CommentDataManager.h"
#import "CommentDataManager+DataEngine.h"
#import "UIViewController+Toast.h"


@implementation HomeTopicDetailController (request)
- (void)loadTopicDetailData:(HomeTopicModel *)model {
    NSString * topic_id = model.topic_id;
    if (!topic_id || [topic_id length] < 1) {
        return;
    }
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"topic_id":topic_id,
    };
    CommentTopicDetailAPIConfig * config = [[CommentTopicDetailAPIConfig alloc] initWithRequestType:CommentRequestTypeGet parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (code && [code integerValue] == 0) {
               //成功
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
