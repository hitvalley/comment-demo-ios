//
//  CommentDataManager.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/11.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface CommentDataManager : NSObject

@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) NSString * user_id;//用户ID
@property (nonatomic, strong) NSString * token;//登录token
@property (nonatomic, strong) NSString * username;//用户名
@property (nonatomic, strong) NSString * avatar; //用户头像

@property (nonatomic, weak) UIViewController * enterCtrl;

+ (instancetype)shareCommentDataManager;
@end

//NS_ASSUME_NONNULL_END
