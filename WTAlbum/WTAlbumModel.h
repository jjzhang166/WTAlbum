//
//  WTAlbumModel.h
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WTAlbumCell.h"

@interface WTAlbumModel : NSObject

/** 
 设置图片默认缩放数据
 */
+ (void)setDataWithAlbumCell:(WTAlbumCell* )albumCell;

/**
 根据具体数据改变图片缩放
 */
+ (void)reloadDataWithScrollView:(UIScrollView* )scrollView imageView:(UIImageView* )imageView;

/**
 根据双击位置获取相应数据
 */
+ (CGRect)zoomRectForScrollView:(UIScrollView* )srcollView scale:(CGFloat )scale withCenter:(CGPoint)center;

@end
