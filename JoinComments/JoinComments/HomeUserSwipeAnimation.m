//
//  HomeUserSwipeAnimation.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/15.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeUserSwipeAnimation.h"
#import "HomeUserController.h"

@implementation HomeUserSwipeAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView * pageView = nil;
    if([fromViewController isKindOfClass:[HomeUserController class]]){
        HomeUserController * userCtr = (HomeUserController *)fromViewController;
        pageView = userCtr.pageView;
    }else if ([toViewController isKindOfClass:[HomeUserController class]]){
        HomeUserController * userCtr = (HomeUserController *)toViewController;
        pageView = userCtr.pageView;
    }
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    BOOL presented = NO; //为present 或者dismiss
    if (toViewController.presentingViewController == fromViewController) {
        presented = YES;
    }
    if (presented) {    //从左往右
        if (pageView) {
            pageView.alpha = 0;
        }
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, -toFrame.size.width, 0);
        [containerView addSubview:toView];
    } else {            //从右往左
        fromView.frame = fromFrame;
        toView.frame = toFrame;
        [containerView insertSubview:toView belowSubview:fromView];
    }
    NSTimeInterval interval =  [self transitionDuration:transitionContext];
    [UIView animateWithDuration:interval animations:^{
        if (presented) {
            if (pageView) {
                pageView.alpha = 1;
            }
            toView.frame = toFrame;
            
        } else {
            fromView.frame = CGRectOffset(fromFrame, -fromFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        BOOL canceled = [transitionContext transitionWasCancelled];
        if (canceled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!canceled];
    }];
}

@end
