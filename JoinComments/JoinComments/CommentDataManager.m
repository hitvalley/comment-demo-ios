//
//  CommentDataManager.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "CommentDataManager.h"

@implementation CommentDataManager


static CommentDataManager * _instance;

+ (instancetype)shareCommentDataManager {
    return [[self alloc] init];
}
#pragma mark- 单例方法

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
//+ (id)copyWithZone:(struct _NSZone *)zone{
//    return  _instance;
//}
//+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
//    return _instance;
//}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}



@end
