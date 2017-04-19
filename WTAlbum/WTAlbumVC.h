//
//  WTAlbumVC.h
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAlbumCell.h"
@class WTAlbumVC;

@protocol WTAlbumVCDelegate <NSObject>

@optional
/**
 照片保存回调
 */
- (void)albumVC:(WTAlbumVC* )albumVC saveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end

@interface WTAlbumVC : UIViewController

/**
 代理
 */
@property (nonatomic,weak)id<WTAlbumVCDelegate> delegate;

/**
 imageArr（NSString or UIImage）
 */
@property (nonatomic,copy)NSArray* imageArr;
/**
 照片位置（selectionIndex必须介于0-imageArr.count之间！）
 */
@property (nonatomic,assign)NSUInteger selectionIndex;
/**
 viewArr（用于展示进入和退出动画）
 */
@property (nonatomic,copy)NSArray<UIView* >* viewArr;

@end
