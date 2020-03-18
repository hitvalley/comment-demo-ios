//
//  ViewController+request.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "HomeTopicModel.h"
//NS_ASSUME_NONNULL_BEGIN

@interface ViewController (request)

- (void)loadTopicListWithPageNum:(NSInteger)num andPageSize:(NSInteger)size endRefresh:(BOOL)end;
- (void)loadMoreTopicListWithPageNum:(NSInteger)num andPageSize:(NSInteger)size endRefresh:(BOOL)end;
- (void)deleteTopicWithModel:(HomeTopicModel *)model;
- (void)addTopicWithTitle:(NSString *)title;
@end

//NS_ASSUME_NONNULL_END
