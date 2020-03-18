//
//  UIBarButtonItem+Custom.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Custom)
+ (UIBarButtonItem *)backButtonWithtitle:(NSString *)title target:(NSObject *)target selector:(SEL)selector;
+ (UIBarButtonItem *)backButtonWithImage:(NSString *)nImage highlightedImage:(NSString *)hImage target:(NSObject *)target selector:(SEL)selector;
@end

//NS_ASSUME_NONNULL_END
