//
//  ViewController+request.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "ViewController+request.h"
#import "UIViewController+Toast.h"

#import <UIKit/UIKit.h>
#import "CommentDataManager.h"
#import "CommentDataManager+DataEngine.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeTopicModel.h"

@implementation ViewController (request)
- (void)loadTopicListWithPageNum:(NSInteger)num andPageSize:(NSInteger)size endRefresh:(BOOL)end{
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        if (end) {
            [self.pageTableView.mj_header endRefreshing];
        }
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"page_no":@(num),
        @"page_size":@(size),
        @"sort_direction":@(-1)
    };
    CommentTopicListAPIConfig * config = [[CommentTopicListAPIConfig alloc] initWithRequestType:CommentRequestTypeGet parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if(end){
            [self.pageTableView.mj_header endRefreshing];
        }
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
                NSNumber * count = [data objectForKey:@"count"];
                
                NSArray * array = [data objectForKey:@"list"];
                NSArray * modelArray = [HomeTopicModel generateModelArrayFromArray:array];
                if (modelArray && [modelArray count] > 0) {
                    [self.dataArray removeAllObjects];
                    self.pageNumber = 0;
                    for (NSInteger i= [modelArray count] - 1; i >= 0; i--) {
                        [self.dataArray addObject:modelArray[i]];
                    }
//                    [self.dataArray addObjectsFromArray:modelArray];
                    [self.pageTableView reloadData];
                }
            }else {
                [self showTextToast:msg];
            }
            NSLog(@"msg = %@", msg);
        }
    } failBlock:^(NSError * _Nullable error) {
        if(end){
            [self.pageTableView.mj_header endRefreshing];
        }
        [self showTextToast:@"网络异常请稍后再试"];
    }];
}

- (void)loadMoreTopicListWithPageNum:(NSInteger)num andPageSize:(NSInteger)size endRefresh:(BOOL)end {
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        if (end) {
            [self.pageTableView.mj_footer endRefreshing];
        }
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"page_no":@(num),
        @"page_size":@(size),
        @"sort_direction":@(-1)
    };
    CommentTopicListAPIConfig * config = [[CommentTopicListAPIConfig alloc] initWithRequestType:CommentRequestTypeGet parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if(end){
            [self.pageTableView.mj_footer endRefreshing];
        }
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            if (code && [code integerValue] == 0) {
                NSNumber * count = [data objectForKey:@"count"];
                NSArray * array = [data objectForKey:@"list"];
                NSArray * modelArray = [HomeTopicModel generateModelArrayFromArray:array];
                if (modelArray && [modelArray count] > 0) {
                    self.pageNumber = num;
//                    [self.dataArray addObjectsFromArray:modelArray];
                    for (NSInteger i= [modelArray count] - 1; i >= 0; i--) {
                        [self.dataArray addObject:modelArray[i]];
                    }
                    [self.pageTableView reloadData];
                }
            }else {
                [self showTextToast:msg];
            }
            NSLog(@"msg = %@", msg);
        }
    } failBlock:^(NSError * _Nullable error) {
        if(end){
            [self.pageTableView.mj_footer endRefreshing];
        }
        [self showTextToast:@"网络异常请稍后再试"];
    }];
}

- (void)deleteTopicWithModel:(HomeTopicModel *)model {
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        return;
    }
    if (!model.topic_id || [model.topic_id length] < 1) {
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"topic_id":model.topic_id,
    };
    CommentTopicDeleteAPIConfig * config = [[CommentTopicDeleteAPIConfig alloc] initWithRequestType:CommentRequestTypePostJson parameters:params headers:headers];
       [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
           
           if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
               NSNumber * code = [responseObject objectForKey:@"code"];
               NSString * msg = [responseObject objectForKey:@"msg"];
               if (code && [code integerValue] == 0) {
                   __block NSInteger index = -1;
                   [self.dataArray enumerateObjectsUsingBlock:^(HomeTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       if ([obj.topic_id isEqualToString:model.topic_id]) {
                           index = idx;
                           *stop = true;
                       }
                   }];
                   if (index >= 0 && index < [self.dataArray count]) {
                       [self.dataArray removeObjectAtIndex:index];
                       [self.pageTableView reloadData];
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
- (void)addTopicWithTitle:(NSString *)title {
    if (!title || [title length] < 1) {
        return;
    }
    NSString * token = [CommentDataManager shareCommentDataManager].token;
    if (!token || [token length] < 1) {
        return;
    }
    NSDictionary * headers = @{@"x-comment-demo-token":token};
    NSDictionary * params = @{
        @"topic_title":title,
    };
    CommentTopicAddAPIConfig * config = [[CommentTopicAddAPIConfig alloc] initWithRequestType:CommentRequestTypePostJson parameters:params headers:headers];
    [CommentDataManager startRequestConfig:config successBlock:^(id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber * code = [responseObject objectForKey:@"code"];
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (code && [code integerValue] == 0) {
               //成功
               [self.pageTableView.mj_header beginRefreshing];
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
