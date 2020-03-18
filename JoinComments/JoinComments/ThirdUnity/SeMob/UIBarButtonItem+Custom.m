//
//  UIBarButtonItem+Custom.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

#import <UIKit/UIKit.h>


@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)backButtonWithtitle:(NSString *)title
                                  target:(NSObject *)target
                                selector:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 1, 50, 20)];
//    button.expandRespondZone = UIEdgeInsetsMake(12, 0, 12, 20);
    [button addTarget:target
              action:selector
    forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [button sizeToFit];
    button.frame = CGRectMake(-5, 0, button.bounds.size.width+13, button.bounds.size.height);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(1,10,-1,0)];
    [view addSubview:button];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)backButtonWithImage:(NSString *)nImage
                        highlightedImage:(NSString *)hImage
                                  target:(NSObject *)target
                                selector:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-10, 1, 50, 20)];
    [button addTarget:target
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:nImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    button.frame = CGRectMake(-5, 0, button.bounds.size.width+13, button.bounds.size.height);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(1,10,-1,0)];
    [view addSubview:button];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return barButtonItem;
}

@end
