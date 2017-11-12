//
//  ViewController.m
//  WTAlbum
//
//  Created by vaexiin on 2017/11/12.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "WTAlbumVC.h"
#import <UIImageView+WebCache.h>

static NSString* const cellId = @"kCollectionViewCell";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WTAlbumVCDelegate>
{
    NSArray* _collectionImageArr;
    NSString* _imageUrl;
    
    UICollectionView* _collection;
    UIPageControl* _page;
}

@end

@implementation ViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _collectionImageArr = @[@"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fwww.qqpk.cn%2FArticle%2FUploadFiles%2F201410%2F20141015092732373.jpg&thumburl=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D171918920%2C1546681003%26fm%3D27%26gp%3D0.jpg",@"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg1.3lian.com%2Fimg013%2Fv1%2F95%2Fd%2F4.jpg&thumburl=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D323217834%2C2814352231%26fm%3D27%26gp%3D0.jpg",@"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F13%2F40%2F15%2F12358PICmWi_1024.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D4248630513%2C351188587%26fm%3D27%26gp%3D0.jpg"];
    _imageUrl = @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fwww.qqpk.cn%2FArticle%2FUploadFiles%2F201410%2F20141015092732373.jpg&thumburl=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D171918920%2C1546681003%26fm%3D27%26gp%3D0.jpg";
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*2/3.0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.width*2/3.0) collectionViewLayout:layout];
    [self.view addSubview:_collection];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor lightGrayColor];
    [_collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellId];
    _page = [UIPageControl new];
    [self.view addSubview:_page];
    _page.frame = CGRectMake(0, _collection.frame.origin.y+_collection.frame.size.height-30, _collection.frame.size.width, 30);
    _page.numberOfPages = _collectionImageArr.count;
    _page.pageIndicatorTintColor = [UIColor blackColor];
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    
    UIImageView* imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, _collection.frame.size.height+_collection.frame.origin.y+10, 100, 100);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    imageView.clipsToBounds = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    imageView.userInteractionEnabled = YES;
    
    UIImageView* otherImageView = [UIImageView new];
    otherImageView.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+10, imageView.frame.origin.y, 100, 100);
    otherImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:otherImageView];
    otherImageView.clipsToBounds = YES;
    [otherImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherImageClick:)]];
    otherImageView.image = [UIImage imageNamed:@"1.jpg"];
    otherImageView.userInteractionEnabled = YES;
}

//tap
- (void)imageClick:(UITapGestureRecognizer* )tap;
{
    WTAlbumVC* album = [WTAlbumVC new];
    album.imageArr = @[_imageUrl];
    [self presentViewController:album animated:YES completion:nil];
}
- (void)otherImageClick:(UITapGestureRecognizer* )tap;
{
    UIImageView* imageView = (UIImageView* )tap.view;
    WTAlbumVC* album = [WTAlbumVC new];
    album.imageArr = @[imageView.image];
    [self presentViewController:album animated:YES completion:nil];
}

//delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    int index = scrollView.contentOffset.x/self.view.bounds.size.width+0.5;
    _page.currentPage = index;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _collectionImageArr.count;
}
- (__kindof UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(CollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_collectionImageArr[indexPath.row]]];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WTAlbumVC* album = [WTAlbumVC new];
    album.imageArr = _collectionImageArr;
    album.selectionIndex = indexPath.item;
    album.delegate = self;
    [self presentViewController:album animated:YES completion:nil];
}

//album delegate
- (void)albumVC:(WTAlbumVC* )albumVC didScrollToIndex:(NSUInteger )index;
{
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
