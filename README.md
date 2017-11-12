# WTAlbum
图片展示控件

https://github.com/Sean-LWT/WTAlbum

![效果](https://github.com/Sean-LWT/WTAlbum/blob/master/screenshot.gif)

使用方法 （需配合SDWebImage使用）

    WTAlbumVC* albumVC = [WTAlbumVC new]; //创建
    albumVC.imageArr = @[top,mid,bottom]; //imageUrl数组
    albumVC.selectionIndex = 1;
    [self presentViewController:albumVC animated:YES completion:nil];

2017-03-08
·first release；

2017-03-13
.优化展示动画;

2017-04-19
.优化手势效果;

2017-04-30
.优化轮播;

2017-11-12
.修复Bug;
