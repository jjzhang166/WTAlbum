//
//  WTAlbumVC.m
//
//  Created by Sean on 2017/2/10.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumVC.h"
#import <objc/runtime.h>
#import "WTAlbumPresentModel.h"

static const char* kImageKey = "kImageKey";

static NSString* const cellId = @"WTAlbumVCCell";

@interface WTAlbumVC () <UICollectionViewDelegate,UICollectionViewDataSource,WTAlbumCellDelgate,UIActionSheetDelegate,UIViewControllerTransitioningDelegate>
{
    BOOL _isAnimation; //是否显示动画
}

@property (nonatomic,strong)UICollectionView* collection; //展示界面（采用缓存机制的UICollectionView）

@property (nonatomic,strong)UIPageControl* pageControl; //UIPageControl

@end

@implementation WTAlbumVC

#pragma mark - 初始化设置
- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        self.transitioningDelegate = self;
        _selectionIndex = 0;
        _imageArr = @[];
        _viewArr = @[];
        
        [self addObserver:self forKeyPath:@"imageArr" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"selectionIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - 设置UI
- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kWidth, kHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)collectionViewLayout:layout];
    [self.view addSubview:_collection];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsSelection = NO;
    [_collection registerClass:[WTAlbumCell class] forCellWithReuseIdentifier:cellId];
    _collection.backgroundColor = [UIColor blackColor];
    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.showsVerticalScrollIndicator = NO;
    
    _pageControl = [UIPageControl new];
    [self.view addSubview:_pageControl];
    _pageControl.frame = CGRectMake(0, kHeight-30, kWidth, 30);
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    
    //设置数据
    _pageControl.numberOfPages = _imageArr.count;
    _pageControl.currentPage = _selectionIndex;
    if(_selectionIndex < _imageArr.count)
    {
        [self scrollToIndex:_selectionIndex];
    }
}
- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
}
#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _imageArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (UICollectionViewCell* )collectionView:(UICollectionView* )collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
{
    WTAlbumCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(WTAlbumCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [cell reloadCellWithImage:[_imageArr objectAtIndex:indexPath.row] index:indexPath.row];
}
#pragma mark 改变pageControl代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    _pageControl.currentPage = scrollView.contentOffset.x/kWidth;
    _selectionIndex = _pageControl.currentPage;
}
#pragma mark cell代理
- (void)albumCell:(WTAlbumCell *)cell didTapImageAtIndex:(NSInteger)index;
{
    [self dismissViewControllerAnimated:_isAnimation completion:nil];
}
- (void)albumCell:(WTAlbumCell *)cell didLongTapImage:(UIImageView *)imageView atIndex:(NSInteger)index;
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* systemVersion = device.systemVersion;
    if ([systemVersion floatValue] >= 8.0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"图片是否保存至相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveImage:imageView.image];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"图片是否保存至相册" delegate:self cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
        objc_setAssociatedObject(sheet, kImageKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        UIImageView* imageView = objc_getAssociatedObject(actionSheet, kImageKey);
        [self saveImage:imageView.image];
    }
}
#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
{
    if([keyPath isEqualToString:@"selectionIndex"])
    {
        //设置数据
        NSAssert(_selectionIndex<_imageArr.count, @"selectionIndex = %zd,imageArr.count = %zd,selectionIndex必须介于0-imageArr.count之间！",_selectionIndex,_imageArr.count);
        _pageControl.currentPage = _selectionIndex;
        [self scrollToIndex:_selectionIndex];
    }
    else if ([keyPath isEqualToString:@"imageArr"])
    {
        //设置数据
        _pageControl.numberOfPages = _imageArr.count;
        _pageControl.currentPage = 0;
        [_collection reloadData];
        if (_imageArr.count)
        {
            [self scrollToIndex:0];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)scrollToIndex:(NSUInteger)index;
{
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
#pragma mark - 其他
/* 保存图片到相册 */
- (void)saveImage:(UIImage* )image;
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
/* 保存回调 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if ([_delegate respondsToSelector:@selector(albumVC:saveImage:didFinishSavingWithError:contextInfo:)])
    {
        [_delegate albumVC:self saveImage:image didFinishSavingWithError:error contextInfo:contextInfo];
    }
}

#pragma mark - 自定义转场
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    _isAnimation = YES;
    if (_viewArr.count)
    {
        WTAlbumCell* cell = (WTAlbumCell* )[_collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectionIndex inSection:0]];
        WTAlbumPresentModel* model = [WTAlbumPresentModel new];
        model.type = WTAlbumPresentModelTypePresent;
        model.fromView = _viewArr[_selectionIndex];
        model.toView = cell.imageView;
        return model;
    }
    else
    {
        return nil;
    }
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    if (_viewArr.count)
    {
        WTAlbumCell* cell = (WTAlbumCell* )[_collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectionIndex inSection:0]];
        WTAlbumPresentModel* model = [WTAlbumPresentModel new];
        model.type = WTAlbumPresentModelTypeDismiss;
        model.toView = _viewArr[_selectionIndex];
        model.fromView = cell.imageView;
        return model;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc;
{
    [self removeObserver:self forKeyPath:@"selectionIndex"];
    [self removeObserver:self forKeyPath:@"imageArr"];
    self.transitioningDelegate = nil;
}

@end
