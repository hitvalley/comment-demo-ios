//
//  HomeTopicDetailController+comment.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/17.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "HomeTopicDetailController.h"

//NS_ASSUME_NONNULL_BEGIN

@interface HomeTopicDetailController (comment)

- (NSString *)getSecondClassTimeStamp;
- (NSString *)getMillisecondTimeStamp;

@end

//NS_ASSUME_NONNULL_END
