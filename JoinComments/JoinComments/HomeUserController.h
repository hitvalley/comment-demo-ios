//
//  HomeUserController.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeUserSwipeAnimation.h"
#import "HomeUserInteractiveTransition.h"
#import "HomeTopicModel.h"

//NS_ASSUME_NONNULL_BEGIN

@interface HomeUserController : UIViewController

@property (nonatomic, strong) UIView * _Nullable pageView;
@property (nonatomic, strong) UIView * _Nullable contentView;
@property (nonatomic, strong) UIView * _Nullable userView;//用户区
@property (nonatomic, strong) UIImageView * _Nullable userIconView;//用户区
@property (nonatomic, strong) UILabel * _Nullable nameLabel;//APP名称
@property (nonatomic, strong) UILabel * _Nullable userRightLabel;//用户权限标识

@property (nonatomic, strong) UIView * _Nullable operattionView;//操作区
@property (nonatomic, strong) UIButton * _Nullable logoutButton;//退出按钮

@property (nonatomic, strong) HomeUserSwipeAnimation * _Nullable transitionAnimation;
@property (nonatomic, strong) HomeUserInteractiveTransition *_Nullable transitionInteractive;
@property (nonatomic, strong) HomeTopicModel * _Nullable entity;


- (void)showContentViewAnimated:(BOOL)animated;
- (void)closeUserControllerAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion;
//- (instancetype)initWithModel:(HomeTopicModel *)model;
@end

//NS_ASSUME_NONNULL_END
