# WTAlbum
图片展示控件

https://github.com/Sean-LWT/WTAlbum

使用方法

    WTAlbumVC* albumVC = [WTAlbumVC new]; //创建
    albumVC.imageArr = @[top,mid,bottom]; //imageUrl数组
    albumVC.selectionIndex = tap.view.tag-1;
    albumVC.viewArr = @[_topImage,_midImage,_bottomImage]; //imageView数组，用于实现转场动画
    [self presentViewController:albumVC animated:YES completion:nil];

2017-03-08
·first release；

2017-03-13
.优化展示动画;

2017-04-19
.优化手势效果;
