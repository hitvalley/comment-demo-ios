//
//  TopicDetailHandler.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/18.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dsbridge.h"

#import "HomeTopicDetailController.h"
//NS_ASSUME_NONNULL_BEGIN

@interface TopicDetailHandler : NSObject
@property (nonatomic, weak) HomeTopicDetailController * ctr;

- (NSString *)getData:(NSString *)data;
@end

//NS_ASSUME_NONNULL_END
