//
//  WTAlbumModel.m
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumModel.h"
#import "SDWebImageManager.h"

@implementation WTAlbumModel

/**
 设置图片默认缩放数据 
 */
+ (void)setDataWithAlbumCell:(WTAlbumCell* )albumCell;
{
    //默认设置
    albumCell.imageView.bounds = CGRectZero;
    albumCell.imageView.image = nil;
    [albumCell.scrollView setZoomScale:1 animated:NO];
    albumCell.scrollView.contentSize = CGSizeMake(0, 0);
    albumCell.noImageBtn.hidden = YES;
    //拿到数据解析判断
    if ([albumCell.image isKindOfClass:[NSString class]])
    {
        [albumCell.indicatorView startAnimating];
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:albumCell.image] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [albumCell.indicatorView stopAnimating];
            if(!error && image && [albumCell.scrollView.accessibilityIdentifier isEqualToString:imageURL.absoluteString])
            {
                UIImage* newImage = [weakSelf scaleImageWithImage:image];
                albumCell.scrollView.contentSize = newImage.size;
                [weakSelf reloadDataWithScrollView:albumCell.scrollView imageView:albumCell.imageView];
                albumCell.imageView.bounds = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
                [albumCell.scrollView setZoomScale:1 animated:NO];
                albumCell.imageView.image = newImage;
            }
            else
            {
                albumCell.noImageBtn.hidden = NO;
            }
        }];
    }
    else if ([albumCell.image isKindOfClass:[UIImage class]])
    {
        UIImage* newImage = [self scaleImageWithImage:albumCell.image];
        albumCell.scrollView.contentSize = newImage.size;
        [self reloadDataWithScrollView:albumCell.scrollView imageView:albumCell.imageView];
        albumCell.imageView.bounds = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
        [albumCell.scrollView setZoomScale:1 animated:NO];
        albumCell.imageView.image = newImage;
    }
    else
    {
        albumCell.noImageBtn.hidden = NO;
    }
}

/**
 压缩图片
 */
+ (UIImage* )scaleImageWithImage:(UIImage* )image;
{
    UIImage* newImage = nil;
    if (image.size.width > kWidth && image.size.height > kHeight)
    {
        CGFloat scale = image.size.width / kWidth;
        newImage = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
    }
    else if (image.size.width > kWidth || image.size.height > kHeight)
    {
        CGFloat scale = 0.0f;
        if(image.size.width > kWidth)
        {
            scale = image.size.width / kWidth;
        }
        else
        {
            scale = image.size.height / kHeight;
        }
        newImage = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
    }
    else
    {
        newImage = image;
    }
    return newImage;
}

/**
 根据具体数据改变图片缩放
 */
+ (void)reloadDataWithScrollView:(UIScrollView* )scrollView imageView:(UIImageView* )imageView;
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

/**
 根据双击位置获取相应数据
 */
+ (CGRect)zoomRectForScrollView:(UIScrollView* )srcollView scale:(CGFloat )scale withCenter:(CGPoint)center;
{
    //截取的信息
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = srcollView.frame.size.height/scale;
    zoomRect.size.width = srcollView.frame.size.width/scale;
    zoomRect.origin.x = center.x-zoomRect.size.width/2.0;
    zoomRect.origin.y = center.y-zoomRect.size.height/2.0;
    return zoomRect;
}

@end
