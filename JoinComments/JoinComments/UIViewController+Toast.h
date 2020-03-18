//
//  UIViewController+Toast.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
//竖屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Toast)
- (void)showTextToast:(NSString *)t;

@end

NS_ASSUME_NONNULL_END
