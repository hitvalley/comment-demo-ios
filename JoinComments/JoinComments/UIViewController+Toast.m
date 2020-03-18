//
//  UIViewController+Toast.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "UIViewController+Toast.h"

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@implementation UIViewController (Toast)

- (void)showTextToast:(NSString *)t {
    if (!t || [t length] < 1) {
        return;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CGFloat time = 2.f;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = t;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
@end
