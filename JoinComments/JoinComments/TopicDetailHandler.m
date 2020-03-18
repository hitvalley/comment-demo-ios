//
//  TopicDetailHandler.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/18.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "TopicDetailHandler.h"

@implementation TopicDetailHandler

- (NSString *)getData:(NSString *)data {
    if (self.ctr) {
        NSString * jsonStr = [self.ctr getProjectCommentData];
        return  jsonStr;
    }
    return nil;
}
@end
