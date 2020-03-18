//
//  CommentDataManager+DataEngine.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDataManager.h"

typedef NS_ENUM (NSUInteger){
    CommentRequestTypeGet,
    CommentRequestTypePost,
    CommentRequestTypePostJson
}CommentRequestType;

typedef void (^CommentHttpSuccess)(_Nullable id responseObject);
typedef void (^CommentHttpFailure)(NSError * _Nullable error);


@interface CommentAPIConfig : NSObject

@property (nonatomic, copy) NSString * _Nullable url;
@property (nonatomic, copy) NSDictionary * _Nullable param;
@property (nonatomic, copy) NSDictionary * _Nullable headers;//请求头带的参数
@property (nonatomic, assign) CommentRequestType method;

- (instancetype _Nullable )initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *_Nullable)param headers:(NSDictionary *_Nullable)header;

@end

//User
@interface CommentRegisterAPIConfig : CommentAPIConfig
@end
@interface CommentUpdateAPIConfig : CommentAPIConfig
@end
@interface CommentLogoutAPIConfig : CommentAPIConfig
@end
@interface CommentLoginAPIConfig : CommentAPIConfig
@end
@interface CommentUserListAPIConfig : CommentAPIConfig
@end
@interface CommentUserDetailAPIConfig : CommentAPIConfig
@end
// Topic
@interface CommentTopicDeleteAPIConfig : CommentAPIConfig
@end
@interface CommentTopicAddAPIConfig : CommentAPIConfig
@end
@interface CommentTopicUpdateAPIConfig : CommentAPIConfig
@end
@interface CommentTopicListAPIConfig : CommentAPIConfig
@end
@interface CommentTopicDetailAPIConfig : CommentAPIConfig
@end


@interface CommentDataManager (DataEngine)
/**
 *  返回NSURLSessionDataTask,调用者自己管理
 */
+ (NSURLSessionDataTask *_Nullable)startRequestConfig:(CommentAPIConfig *_Nullable)requestConfig
                                successBlock:(CommentHttpSuccess _Nullable )success
                                   failBlock:(CommentHttpFailure _Nullable )failure;
@end
