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
@property (nonatomic,strong)UIPageControl* pageControl;   //UIPageControl
@property (nonatomic,strong)UILabel* labelControl;        //labelControl

@end

@implementation WTAlbumVC

#pragma mark - 初始化设置
- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        _selectionIndex = 0;
        _imageArr = @[];
        _pageControlType = WTAlbumVCPageControlTpyeText;
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
    [_collection registerClass:[WTAlbumVCCell class] forCellWithReuseIdentifier:cellId];
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.showsVerticalScrollIndicator = NO;
    
    _pageControl = [UIPageControl new];
    [self.view addSubview:_pageControl];
    _pageControl.frame = CGRectMake(0, kHeight-30, kWidth, 30);
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    
    _labelControl = [UILabel new];
    [self.view addSubview:_labelControl];
    _labelControl.textAlignment = NSTextAlignmentCenter;
    _labelControl.frame = CGRectMake(0, 58, kWidth, 30);
    
    //设置数据
    [self sharePageIndex];
    [self setPageControlType:_pageControlType];
}
#pragma mark - 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [self setPageControlIndex:scrollView.contentOffset.x/kWidth];
    _selectionIndex = _pageControl.currentPage;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _imageArr.count;
}
- (UICollectionViewCell* )collectionView:(UICollectionView* )collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
{
    WTAlbumVCCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(WTAlbumVCCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [cell reloadCellWithImage:[_imageArr objectAtIndex:indexPath.row] index:indexPath.row];
}
#pragma mark - set/get
- (void)sharePageIndex;
{
    _pageControl.numberOfPages = _imageArr.count;
    if (_selectionIndex >= _imageArr.count && _imageArr.count) _selectionIndex = _imageArr.count-1;
    else if(_imageArr.count == 0) _selectionIndex = 0;
    [self setPageControlIndex:_selectionIndex];
    [self scrollToIndex:_selectionIndex];
}
- (void)scrollToIndex:(NSUInteger)index;
{
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (void)setSelectionIndex:(NSUInteger)selectionIndex;
{
    _selectionIndex = selectionIndex;
    if (_labelControl) [self sharePageIndex];
}
- (void)setImageArr:(NSArray *)imageArr;
{
    _imageArr = imageArr?:@[];
    if (_labelControl)
    {
        [_collection reloadData];
        [self sharePageIndex];
    }
}
- (void)setPageControlIndex:(NSInteger )index;
{
    _pageControl.currentPage = index;
    NSMutableAttributedString* labelControlText = [NSMutableAttributedString new];
    NSString* leftStr = [NSString stringWithFormat:@"%zd",_pageControl.currentPage+1];
    NSString* rightStr = [NSString stringWithFormat:@"/%zd",_pageControl.numberOfPages];
    [labelControlText appendAttributedString:[[NSAttributedString alloc] initWithString:leftStr attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]}]];
    [labelControlText appendAttributedString:[[NSAttributedString alloc] initWithString:rightStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]}]];
    _labelControl.attributedText = labelControlText;
    if ([_delegate respondsToSelector:@selector(albumVC:didScrollToIndex:)])
    {
        [_delegate albumVC:self didScrollToIndex:_pageControl.currentPage];
    }
}
- (void)setPageControlType:(WTAlbumVCPageControlTpye)pageControlType;
{
    if (_pageControlType == pageControlType) return;
    _pageControlType = pageControlType;
    if(_pageControlType == WTAlbumVCPageControlTpyeText)
    {
        _pageControl.alpha = 0;
        _labelControl.hidden = NO;
    }
    else if (_pageControlType == WTAlbumVCPageControlTpyeSystemPageControl)
    {
        _pageControl.alpha = 1;
        _labelControl.hidden = YES;
    }
}
#pragma mark cell代理
- (void)albumCell:(WTAlbumVCCell *)cell didTapImageAtIndex:(NSInteger)index;
{
    [self dismissViewControllerAnimated:_isAnimation completion:nil];
}
- (void)albumCell:(WTAlbumVCCell *)cell didLongTapImage:(UIImageView *)imageView atIndex:(NSInteger)index;
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
        objc_setAssociatedObject(sheet, kImageKey, imageView.image, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        [self saveImage:objc_getAssociatedObject(actionSheet, kImageKey)];
    }
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
    return [WTAlbumPresentModel sharePresentModel];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    return [WTAlbumPresentModel shareDismissModel];
}

- (void)dealloc;
{
    self.transitioningDelegate = nil;
}

@end
