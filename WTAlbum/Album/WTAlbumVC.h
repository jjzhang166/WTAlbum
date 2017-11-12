//
//  WTAlbumVC.h
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAlbumVCCell.h"
@class WTAlbumVC;

typedef NS_ENUM(NSUInteger , WTAlbumVCPageControlTpye) {
    WTAlbumVCPageControlTpyeText              = 0,
    WTAlbumVCPageControlTpyeSystemPageControl = 1 << 0,
};

@protocol WTAlbumVCDelegate <NSObject>

@optional
/**
 照片保存回调

 @param albumVC WTAlbumVC对象
 @param image UIImage对象
 @param error 错误信息
 @param contextInfo contextInfo对象
 */
- (void)albumVC:(WTAlbumVC* )albumVC saveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

/**
 相册展示位置回调

 @param albumVC WTAlbumVC对象
 @param index 位置
 */
- (void)albumVC:(WTAlbumVC* )albumVC didScrollToIndex:(NSUInteger )index;

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
 照片位置
 */
@property (nonatomic,assign)NSUInteger selectionIndex;
/**
 pagecontrol样式
 */
@property (nonatomic,assign)WTAlbumVCPageControlTpye pageControlType;

@end
