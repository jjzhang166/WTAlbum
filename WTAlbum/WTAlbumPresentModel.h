//
//  WTAlbumPresentModel.h
//  移动硅谷
//
//  Created by Sean on 2017/3/7.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    WTAlbumPresentModelTypePresent = 0,
    WTAlbumPresentModelTypeDismiss,
}WTAlbumPresentModelType;

@interface WTAlbumPresentModel : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)WTAlbumPresentModelType type;
@property (nonatomic,weak)UIView* fromView;
@property (nonatomic,weak)UIView* toView;

@end
