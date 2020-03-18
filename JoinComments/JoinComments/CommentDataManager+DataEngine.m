//
//  CommentDataManager+DataEngine.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "CommentDataManager+DataEngine.h"
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

//User
@interface CommentRegisterAPIConfig()
@end
@interface CommentUpdateAPIConfig()
@end
@interface CommentLogoutAPIConfig()
@end
@interface CommentLoginAPIConfig()
@end
@interface CommentUserListAPIConfig()
@end
@interface CommentUserDetailAPIConfig()
@end
// Topic
@interface CommentTopicDeleteAPIConfig()
@end
@interface CommentTopicAddAPIConfig()
@end
@interface CommentTopicUpdateAPIConfig()
@end
@interface CommentTopicListAPIConfig()
@end
@interface CommentTopicDetailAPIConfig()
@end

@implementation CommentAPIConfig

- (instancetype _Nullable )initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *_Nullable)param headers:(NSDictionary *_Nullable)header{
    self = [super init];
    if (self){
        self.method = method;
        self.param = param;
        self.headers = header;
    }
    return self;
}
@end

#pragma mark - User
@implementation CommentRegisterAPIConfig

- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/register";
    }
    return self;
}
@end

@implementation CommentUpdateAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/update";
    }
    return self;
}
@end

@implementation CommentLogoutAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/logout";
    }
    return self;
}
@end

@implementation CommentLoginAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/login";
    }
    return self;
}
@end

@implementation CommentUserListAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/list";
    }
    return self;
}
@end

@implementation CommentUserDetailAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/user/detail";
    }
    return self;
}
@end

#pragma mark - Topic
@implementation CommentTopicDeleteAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/topic/delete";
    }
    return self;
}
@end

@implementation CommentTopicAddAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/topic/add";
    }
    return self;
}
@end
@implementation CommentTopicUpdateAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/topic/update";
    }
    return self;
}
@end
@implementation CommentTopicListAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/topic/list";
    }
    return self;
}
@end
@implementation CommentTopicDetailAPIConfig
- (instancetype)initWithRequestType:(CommentRequestType)method parameters:(NSDictionary *)param headers:(NSDictionary *_Nullable)header
{
    self = [super initWithRequestType:method parameters:param headers:header];
    if (self){
        self.url = @"http://api.demo.valleyjs.cn/topic/detail";
    }
    return self;
}
@end


@implementation CommentDataManager (DataEngine)

+ (NSURLSessionDataTask *)startRequestConfig:(CommentAPIConfig *)config successBlock:(CommentHttpSuccess)success failBlock:(CommentHttpFailure)failure{
    CommentRequestType method = config.method;
    NSString *path = config.url;
    NSDictionary *param = config.param;
    NSURLSessionDataTask *task;
    switch (method) {
        case CommentRequestTypeGet:
            task = [CommentDataManager GET:path parameters:param headers:config.headers method:method success:success failure:failure];
            break;
        case CommentRequestTypePost:
        case CommentRequestTypePostJson:
            task = [CommentDataManager POST:path parameters:param headers:config.headers method:method  success:success failure:failure];
            break;
        default:
            break;
    }
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)url parameters:(id)parameters headers:(id)headers method:(CommentRequestType)method success:(CommentHttpSuccess)success failure:(CommentHttpFailure)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (method == CommentRequestTypePostJson) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }else{
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    // 设置请求头参数
    // token
//    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSURLSessionDataTask *task = [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {success(responseObject);}
//        [manager invalidateSessionCancelingTasks:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {failure(error);}
//        [manager invalidateSessionCancelingTasks:YES];
//    }];
//    return task;
    if (headers && [headers count] > 0) {
        [[headers allKeys] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:headers[obj] forHTTPHeaderField:obj];
        }];
    }
    
    NSURLSessionDataTask * task = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {success(responseObject);}
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {failure(error);}
        [manager invalidateSessionCancelingTasks:YES];
    }];
    return task;
}

+ (NSURLSessionDataTask *)GET:(NSString *)url parameters:(id)parameters headers:(id)headers  method:(CommentRequestType)method success:(CommentHttpSuccess)success failure:(CommentHttpFailure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSURLSessionDataTask *task = [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {success(responseObject);}
//        [manager invalidateSessionCancelingTasks:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {failure(error);}
//        [manager invalidateSessionCancelingTasks:YES];
//    }];
//    return task;
    if (headers && [headers count] > 0) {
        [[headers allKeys] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:headers[obj] forHTTPHeaderField:obj];
        }];
    }
    NSURLSessionDataTask *task = [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {success(responseObject);}
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {failure(error);}
        [manager invalidateSessionCancelingTasks:YES];
    }];
    return task;
}

@end
