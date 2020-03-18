//
//  HomeTopicModel.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/13.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeTopicModel.h"

@implementation HomeTopicModel
+ (HomeTopicModel *)generateTopicModelFromDictionary:(NSDictionary *)dic {
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    HomeTopicModel * model = [HomeTopicModel new];
    NSString * userid = [dic objectForKey:@"_id"];
    NSNumber * create_time = [dic objectForKey:@"create_time"];
    NSNumber * is_delete = [dic objectForKey:@"is_delete"];
    NSString * topic_id = [dic objectForKey:@"topic_id"];
    NSString * topic_title = [dic objectForKey:@"topic_title"];
    NSNumber * update_time = [dic objectForKey:@"update_time"];
    if (userid && [userid isKindOfClass:[NSString class]]) {
        model.user_id = userid;
    }else {
        model.user_id = nil;
    }
    if (create_time && [create_time isKindOfClass:[NSNumber class]]) {
        model.create_time = [create_time longLongValue];
    }else {
        model.create_time = 0;
    }
    if (is_delete && [is_delete isKindOfClass:[NSNumber class]]) {
        model.is_delete = [is_delete boolValue];
    }else {
        model.is_delete = false;
    }
    if (topic_id && [topic_id isKindOfClass:[NSString class]]) {
        model.topic_id = topic_id;
    }else {
        model.topic_id = nil;
    }
    if (topic_title && [topic_title isKindOfClass:[NSString class]]) {
        model.topic_title = topic_title;
    }else {
        model.topic_title = nil;
    }
    if (update_time && [update_time isKindOfClass:[NSNumber class]]) {
        model.update_time = [update_time longLongValue];
    }else {
        model.update_time = 0;
    }
    return model;
}

+ (NSArray *)generateModelArrayFromArray:(NSArray *)array {
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    __block NSMutableArray * arrayTemp = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeTopicModel * model = [HomeTopicModel generateTopicModelFromDictionary:obj];
        [arrayTemp addObject:model];
    }];
    return arrayTemp;
}
@end
