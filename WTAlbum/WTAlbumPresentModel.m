//
//  WTAlbumPresentModel.m
//  移动硅谷
//
//  Created by Sean on 2017/3/7.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumPresentModel.h"

@interface WTAlbumPresentModel ()

@end

@implementation WTAlbumPresentModel

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.35;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //tempView
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    //计算位置
    if (_type == WTAlbumPresentModelTypePresent)
    {
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        toViewController.view.alpha = 0;
        fromViewController.view.alpha = 1;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.alpha = 1;
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            toViewController.view.alpha = 1;
            fromViewController.view.alpha = 1;
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        UIView* fromTempView = [_fromView snapshotViewAfterScreenUpdates:NO];
        CGRect fromRect = [_fromView convertRect:_fromView.bounds toView:window];
        CGRect toRect = [_toView convertRect:_toView.bounds toView:window];
        [containerView addSubview:fromTempView];
        fromTempView.frame = fromRect;
        CGRect endRect = CGRectMake(toRect.origin.x+toRect.size.width/2.0, toRect.origin.y+toRect.size.height/2.0 ,0 ,0);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromTempView.frame = endRect;
        } completion:^(BOOL finished) {
            [fromTempView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
