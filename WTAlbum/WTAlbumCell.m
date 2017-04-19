//
//  WTAlbumCell.m
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumCell.h"
#import "WTAlbumModel.h"

@interface WTAlbumCell ()<UIScrollViewDelegate>
{
    CGFloat oldScale; //保存的放大信息
}

@end

@implementation WTAlbumCell

#pragma mark - 初始化数据
- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [UIScrollView new];
        [self .contentView addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.decelerationRate = 1.0;
        _scrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = self.contentView.center;
        [self.contentView addSubview:_indicatorView];
        
        _noImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_noImageBtn];
        [_noImageBtn setImage:[UIImage imageNamed:@"WTAlbumForNoImage"] forState:UIControlStateNormal];
        _noImageBtn.bounds = CGRectMake(0, 0, 60, 60);
        _noImageBtn.center = self.contentView.center;
        [_noImageBtn addTarget:self action:@selector(reloadImageClick:) forControlEvents:UIControlEventTouchUpInside];
        _noImageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _noImageBtn.hidden = YES;
        
        /* 手势 */
        //单击
        UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontTapClick:)];
        [_scrollView addGestureRecognizer:oneTap];
        //双击
        UITapGestureRecognizer* twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapClick:)];
        twoTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:twoTap];
        [oneTap requireGestureRecognizerToFail:twoTap];
        //长按
        UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClick:)];
        longTap.minimumPressDuration = 0.5;
        [_scrollView addGestureRecognizer:longTap];
    }
    return self;
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
}
#pragma mark - 刷新cell
- (void)reloadCellWithImage:(id )image index:(NSInteger )index;
{
    _image = image;
    _index = index;
    oldScale = 1;
    _scrollView.accessibilityIdentifier = [image isKindOfClass:[NSString class]]?image:@""; //记录
    [WTAlbumModel setDataWithAlbumCell:self];
}

#pragma mark - 手势响应
- (void)ontTapClick:(UITapGestureRecognizer* )oneTap;
{
    if ([_delegate respondsToSelector:@selector(albumCell:didTapImageAtIndex:)])
    {
        [_delegate albumCell:self didTapImageAtIndex:_index];
    }
}
- (void)twoTapClick:(UITapGestureRecognizer* )twoTap;
{
    if (oldScale >= 1.5)
    {
        [_scrollView setZoomScale:1.0f animated:YES];
    }
    else
    {
        [_scrollView zoomToRect:[WTAlbumModel zoomRectForScrollView:_scrollView scale:2.0f withCenter:[twoTap locationInView:twoTap.view]] animated:YES];
    }
    
}
- (void)longTapClick:(UILongPressGestureRecognizer* )longTap;
{
    if (longTap.state == UIGestureRecognizerStateBegan)
    {
        if ([_delegate respondsToSelector:@selector(albumCell:didLongTapImage:atIndex:)])
        {
            [_delegate albumCell:self didLongTapImage:_imageView atIndex:_index];
        }
    }
}

#pragma mark - 按钮相应
- (void)reloadImageClick:(UIButton* )noImageBtn;
{
    [WTAlbumModel setDataWithAlbumCell:self];
}

#pragma mark - 代理
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
{
    [WTAlbumModel reloadDataWithScrollView:_scrollView imageView:_imageView];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;
{
    //记录放大信息
    oldScale = scale;
}

@end
