//
//  CollectionViewCell.m
//  WTAlbum
//
//  Created by vaexiin on 2017/11/12.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
