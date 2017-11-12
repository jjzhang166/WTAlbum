//
//  WTAlbumPresentModel.h
//  移动硅谷
//
//  Created by Sean on 2017/3/7.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WTAlbumPresentModel : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)sharePresentModel;
+ (instancetype)shareDismissModel;

@end
