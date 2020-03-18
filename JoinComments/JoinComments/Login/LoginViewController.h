//
//  LoginViewController.h
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/12.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Toast.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *nameLine;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *pwdLine;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

NS_ASSUME_NONNULL_END
