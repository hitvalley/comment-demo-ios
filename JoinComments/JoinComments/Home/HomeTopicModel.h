//
//  HomeTopicModel.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/13.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HomeTopicModel : NSObject
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, assign) int64_t  create_time;
@property (nonatomic, assign) BOOL is_delete;
@property (nonatomic, strong) NSString * topic_id;
@property (nonatomic, strong) NSString * topic_title;
@property (nonatomic, assign) int64_t update_time;

+ (HomeTopicModel *)generateTopicModelFromDictionary:(NSDictionary *)dic;
+ (NSArray *)generateModelArrayFromArray:(NSArray *)array;
@end

