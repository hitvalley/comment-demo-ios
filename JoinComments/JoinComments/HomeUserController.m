//
//  HomeUserController.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeUserController.h"
#import "UIViewController+Toast.h"
#import "SemobSystemInfo.h"
#import "CommentDataTool.h"
#import "HomeUserController+request.h"
#import "CommentDataManager.h"

typedef NS_ENUM(NSInteger, CommentUserPanMode) {
    CommentUserPanNormal,
    CommentUserPanSpeed
};
typedef NS_ENUM(NSInteger, CommentUserPanDirection) {
    CommentUserPanLeft,
    CommentUserPanRight,
    CommentUserPanDown,
    CommentUserPanUp
};

@interface HomeUserController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIPanGestureRecognizer * panRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer * tapRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;
@property (nonatomic, assign) CommentUserPanMode panMode;
@property (nonatomic, assign) CommentUserPanDirection panDirection;
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation HomeUserController


- (instancetype)initWithModel:(HomeTopicModel *)model {
    self = [super init];
    if (self) {
        self.entity = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.transitioningDelegate = self;//启用转场动画
    self.view.backgroundColor = [UIColor clearColor];
    [self setupSubView];
    [self.view addGestureRecognizer:self.panRecognizer];
    UITapGestureRecognizer *  tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewGesture:)];
    [tap setNumberOfTapsRequired:1];
    tap.delegate = self;
    [self.pageView addGestureRecognizer:tap];
    self.tapRecognizer = tap;
    [self.panRecognizer requireGestureRecognizerToFail:self.tapRecognizer];
    self.panMode = CommentUserPanNormal;
    CommentDataManager * manager = [CommentDataManager shareCommentDataManager];
    [self loadUserDetailData:manager.user_id];
}

- (void)setupSubView {
    UIView * sView = self.view;
    CGFloat maxValue = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat minValue = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat rightMargin = 80.f;
    UIView * pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, minValue, maxValue)];
    pView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [sView addSubview:pView];
    pView.alpha = 0;
    self.pageView = pView;
    
    UIView * cView = [[UIView alloc] initWithFrame:CGRectMake(-(minValue-rightMargin), 0, minValue-rightMargin, maxValue)];
    cView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [sView addSubview:cView];
    self.contentView = cView;
    
    CGFloat uHeight = 180;
    if ([[SemobSystemInfo Instance] isIPhoneXSeries]) {
        uHeight = 180 + 14;
    }
    UIView * uView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, minValue-rightMargin, uHeight)];
    uView.backgroundColor = [UIColor systemGreenColor];
    [cView addSubview:uView];
    self.userView = uView;
    
    UIImageView * iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor lightGrayColor];
    iconView.image = [UIImage imageNamed:@"user_avatar_default"];
    [uView addSubview:iconView];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftCons = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    NSLayoutConstraint *topCons = nil;
    if (@available(iOS 11.0, *)) {
        topCons = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:uView.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    }else {
        topCons = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    }
    topCons.active = YES;
    NSLayoutConstraint * widthCons = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    widthCons.active = YES;
    NSLayoutConstraint * heightCons = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    heightCons.active = YES;
    self.userIconView = iconView;
    
    UILabel * nLabel = [[UILabel alloc] init];
    nLabel.backgroundColor = [UIColor clearColor];
    [nLabel setFont:[UIFont boldSystemFontOfSize:16]];
    nLabel.textColor = [UIColor whiteColor];
    nLabel.textAlignment = NSTextAlignmentLeft;
    nLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nLabel.text = @"";
    [uView addSubview:nLabel];
    nLabel.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:nLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    NSLayoutConstraint *rightCons = [NSLayoutConstraint constraintWithItem:nLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:nLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    topCons.active = YES;
    heightCons = [NSLayoutConstraint constraintWithItem:nLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    heightCons.active = YES;
    self.nameLabel = nLabel;
    
    UILabel * rLabel = [[UILabel alloc] init];
    rLabel.backgroundColor = [UIColor clearColor];
    [rLabel setFont:[UIFont boldSystemFontOfSize:16]];
    rLabel.textAlignment = NSTextAlignmentLeft;
    rLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    rLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    rLabel.text = @"测试用户";
    [uView addSubview:rLabel];
    rLabel.translatesAutoresizingMaskIntoConstraints = NO;
    leftCons = [NSLayoutConstraint constraintWithItem:rLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    leftCons.active = YES;
    rightCons = [NSLayoutConstraint constraintWithItem:rLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:uView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    rightCons.active = YES;
    topCons = [NSLayoutConstraint constraintWithItem:rLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    topCons.active = YES;
    heightCons = [NSLayoutConstraint constraintWithItem:rLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    heightCons.active = YES;
    self.userRightLabel = rLabel;
    
    
    
    //-------------------------------------------------
    
    UIView * oView = [[UIView alloc] initWithFrame:CGRectMake(0, uHeight, minValue-rightMargin, maxValue-uHeight)];
    oView.backgroundColor = [UIColor whiteColor];
    [cView addSubview:oView];
    self.operattionView = oView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    //    button.expandRespondZone = UIEdgeInsetsMake(12, 0, 12, 20);
    [button addTarget:self action:@selector(clickLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"logout_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"logout_press"] forState:UIControlStateHighlighted];
    UIImage * highImage = [CommentDataTool createImageWithColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 10,  minValue-rightMargin, 40);
//    button.contentMode = UIViewContentModeLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(1,50,0,0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1,16,0,0)];
    [oView addSubview:button];
    self.logoutButton = button;
}

- (void)showContentViewAnimated:(BOOL)animated {
    CGFloat maxValue = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat minValue = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat rightMargin = 80.f;
    CGFloat uHeight = 120;
    if ([[SemobSystemInfo Instance] isIPhoneXSeries]) {
        uHeight = 120 + 14;
    }
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
             self.contentView.frame = CGRectMake(0, 0, minValue-rightMargin, maxValue);
        }];
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.pageView.alpha = 1;
        }];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)closeUserControllerAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion{
    if (animated) {
        CGFloat maxValue = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        CGFloat minValue = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        CGFloat rightMargin = 80.f;
        CGFloat uHeight = 120;
        if ([[SemobSystemInfo Instance] isIPhoneXSeries]) {
            uHeight = 120 + 14;
        }
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                self.contentView.frame = CGRectMake(-(minValue-rightMargin), 0, minValue-rightMargin, maxValue);
            }];
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                self.pageView.alpha = 0;
            }];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                if (completion) {
                    completion();
                }
            }];
        }];
    }else {
        [self dismissViewControllerAnimated:NO completion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)clickLogoutButton:(UIButton *) sender {
    NSLog(@"退出登录");
    [self logoutRequestCompletion:^{
        [self showLoginController];
    }];
}
- (void)showLoginController {
    CommentDataManager * manager = [CommentDataManager shareCommentDataManager];
    if(manager.enterCtrl) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * loginNavi = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
        [manager.enterCtrl presentViewController:loginNavi animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (HomeUserSwipeAnimation *)transitionAnimation {
    if (!_transitionAnimation) {
        _transitionAnimation = [HomeUserSwipeAnimation new];
    }
    return _transitionAnimation;
}

- (HomeUserInteractiveTransition *)transitionInteractive {
    if (!_transitionInteractive) {
       _transitionInteractive = [[HomeUserInteractiveTransition alloc] initWithGestureRecognizer:self.panRecognizer edgeForDragging:self.edge];
    }
    return _transitionInteractive;
}
- (UIRectEdge)edge {
    return UIRectEdgeRight;
}
- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startPanGesture:)];
        [_panRecognizer setMaximumNumberOfTouches:1];
    }
    return _panRecognizer;
}
- (void)tapViewGesture:(UITapGestureRecognizer *)ges {
    CGPoint touchPoint = [ges locationInView:self.pageView];
    if (CGRectContainsPoint(self.contentView.frame, touchPoint)) {
        return;
    }
    NSLog(@"点击");
    [self closeUserControllerAnimated:YES completion:nil];
}

- (void)startPanGesture:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始");
        CGFloat speedStrict = 500.f;
        CGFloat xVelocity = [ges velocityInView: self.pageView].x;
        self.startPoint = [ges locationInView:self.pageView];
        if (xVelocity > speedStrict) {
            self.panMode = CommentUserPanSpeed;
        }else {
            self.panMode = CommentUserPanNormal;
            if (xVelocity < 0) {
                self.panDirection = CommentUserPanLeft;
            }else {
                self.panDirection = CommentUserPanRight;
            }
        }
    }else if (ges.state == UIGestureRecognizerStateChanged) {
        if (self.panMode == CommentUserPanSpeed || self.panDirection != CommentUserPanLeft) {
            return;
        }
        CGPoint curPoint = [ges locationInView:self.pageView];
        CGFloat changeX = curPoint.x - self.startPoint.x;
        CGRect curRect = self.contentView.frame;
        CGFloat percent = (curRect.origin.x+changeX)*(-1.f)*1.5/SCREEN_WIDTH;
        if (percent < 0) {
            percent = 0;
        }else if (percent > 1) {
            percent = 1;
        }
        self.pageView.alpha = 1 - percent;
        self.contentView.frame = CGRectMake(MIN(curRect.origin.x+changeX,0), 0, curRect.size.width,  curRect.size.width);
        self.startPoint = curPoint;
        
        NSLog(@"变化中");
    }else {//结束
        NSLog(@"其他");
        [self handlePanGestureFinished];
    }
}

- (void)handlePanGestureChanging:(CGFloat)x {
    CGRect rect = self.contentView.frame;
    self.contentView.frame = CGRectMake(rect.origin.x + x, 0, rect.size.width, rect.size.height);
}
- (void)handlePanGestureFinished {
    if (self.panMode == CommentUserPanSpeed) {
        [self closeUserControllerAnimated:YES completion:nil];
    }else {
        CGRect rect = self.contentView.frame;
        //超过三分之一关闭
        if (0 - rect.origin.x >= (SCREEN_WIDTH/3.0)) {
            [self closeUserControllerAnimated:YES completion:nil];
        }else {//恢复正常
            CGFloat maxValue = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
            CGFloat minValue = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
            CGFloat rightMargin = 80.f;
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                    self.contentView.frame = CGRectMake(0, 0, minValue-rightMargin, maxValue);
                }];
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                    self.pageView.alpha = 1;
                }];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark -- UIViewControllerTransitioningDelegate

//返回一个处理present动画过渡的对象
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.transitionAnimation;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return self.transitionAnimation;
}
//返回一个处理present手势过渡的对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}
//返回一个处理dismiss手势过渡的对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

#pragma mark - UITapGestureRecognizeDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapRecognizer) {
        CGPoint tPoint = [gestureRecognizer locationInView:self.pageView];
        if (CGRectContainsPoint(self.contentView.frame, tPoint)) {
            return false;
        }else {
            return true;
        }
    }else if(gestureRecognizer == self.panRecognizer){
        return YES;
    }else {
        return YES;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
