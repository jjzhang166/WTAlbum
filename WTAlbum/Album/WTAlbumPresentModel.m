//
//  WTAlbumPresentModel.m
//
//  Created by Sean on 2017/3/7.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumPresentModel.h"

typedef enum {
    WTAlbumPresentModelTypePresent = 0,
    WTAlbumPresentModelTypeDismiss,
}WTAlbumPresentModelType;

@interface WTAlbumPresentModel ()

@property (nonatomic,assign)WTAlbumPresentModelType type;

@end

@implementation WTAlbumPresentModel

+ (instancetype)sharePresentModel;
{
    WTAlbumPresentModel* model = [WTAlbumPresentModel new];
    model.type = WTAlbumPresentModelTypePresent;
    return model;
}
+ (instancetype)shareDismissModel;
{
    WTAlbumPresentModel* model = [WTAlbumPresentModel new];
    model.type = WTAlbumPresentModelTypeDismiss;
    return model;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.3;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    //转场动画
    if (_type == WTAlbumPresentModelTypePresent)
    {
        UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView* containerView = [transitionContext containerView];
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromViewController.view.alpha = 1;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
