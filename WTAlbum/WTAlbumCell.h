//
//  WTAlbumCell.h
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTAlbumCell;

#define kWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define maxWidth kWidth*2.0f
#define maxHeight kHeight*2.0f

@protocol WTAlbumCellDelgate <NSObject>

@optional
/** 
 图片单击事件代理
 */
- (void)albumCell:(WTAlbumCell* )cell didTapImageAtIndex:(NSInteger )index;
/**
 图片长按事件代理
 */
- (void)albumCell:(WTAlbumCell *)cell didLongTapImage:(UIImageView* )imageView atIndex:(NSInteger)index;

@end

@interface WTAlbumCell : UICollectionViewCell

/**
 delegate
 */
@property (nonatomic,weak)id <WTAlbumCellDelgate> delegate;
/**
 照片
 */
@property (nonatomic,copy,readonly)id image;
/**
 照片位置
 */
@property (nonatomic,assign,readonly)NSInteger index;
/**
 刷新cell
 */
- (void)reloadCellWithImage:(id )image index:(NSInteger )index;

@property (nonatomic,strong,readonly)UIScrollView* scrollView; //背景scrollView
@property (nonatomic,strong,readonly)UIImageView* imageView; //图片显示imageView
@property (nonatomic,strong,readonly)UIActivityIndicatorView* indicatorView; //加载动画
@property (nonatomic,strong,readonly)UIButton* noImageBtn; //失败按钮

@end
