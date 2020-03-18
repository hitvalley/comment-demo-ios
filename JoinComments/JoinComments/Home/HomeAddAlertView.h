//
//  HomeAddAlertView.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/14.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeMobNewsCommentTextView.h"
//NS_ASSUME_NONNULL_BEGIN
@class HomeAddAlertView;
typedef void (^ConfirmAddBlock)(HomeAddAlertView * _Nullable alert, NSString * _Nullable  content);
typedef void (^CancelAddBlock)(HomeAddAlertView * _Nullable alert);

@interface HomeAddAlertView : UIView

@property(nonatomic, copy) ConfirmAddBlock _Nullable confirmBlock;
@property(nonatomic, copy) CancelAddBlock _Nullable cancelBlock;
@property(nonatomic, strong) SeMobNewsCommentTextView * _Nullable inputTextView;
+ (HomeAddAlertView *_Nullable)showAddAlerViewConfirm:(ConfirmAddBlock _Nullable ) addBlock cancel:(CancelAddBlock _Nullable ) cancelBlock;

@end

//NS_ASSUME_NONNULL_END
