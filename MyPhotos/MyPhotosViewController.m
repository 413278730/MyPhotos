//
//  MyPhotosViewController.m
//  MyPhotos
//
//  Created by 邓金龙 on 15/12/21.
//  Copyright © 2015年 邓金龙. All rights reserved.
//

#import "MyPhotosViewController.h"
#define IMAGEVIEW_TAG 5800

@interface MyPhotosViewController ()<UIScrollViewDelegate>

@end

@implementation MyPhotosViewController
{
    UIScrollView* _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //设置导航栏样式
    [self setNav];
    [self createScrollView];
    [self createImageView];
    [self createMineBtn];
}
#pragma mark 设置导航栏
- (void)setNav
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem* barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
}
#pragma mark 创建UI
- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44)];
    _scrollView.delegate = self;
    if (self.imageArray.count > 2) {
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width*3, 150)];
        [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    }else{
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width*self.imageArray.count, 150)];
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.pagingEnabled = YES;
    //这个方法必须关闭，否则滑动时又白边效果
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
}
//创建imageView，并且贴上初始图片
- (void)createImageView
{
    NSInteger count;
    if (self.imageArray.count > 2) {
        count = 3;
    }else{
        count = self.imageArray.count;
    }
    for (int i = 0; i < count; i ++) {
        //图片
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height-64-44)];
        imageView.tag = IMAGEVIEW_TAG + i;
        //图片标题
        if (count < 3) {
            //当图片小于三张
            if ([self.imageArray[i] isKindOfClass:[NSString class]]) {
                imageView.image = [UIImage imageNamed:self.imageArray[i]];
            }else{
                imageView.image = self.imageArray[i];
            }
        }else{
            //当图片大于三张，复用
            if (i == 1) {
                //当图片小于三张
                if ([self.imageArray[self.currentImageIndex] isKindOfClass:[NSString class]]) {
                    imageView.image = [UIImage imageNamed:self.imageArray[self.currentImageIndex]];
                }else{
                    imageView.image = self.imageArray[self.currentImageIndex];
                }
            }else if (i == 0){
                if (self.currentImageIndex == 0) {
                    if ([[self.imageArray lastObject] isKindOfClass:[NSString class]]) {
                        imageView.image = [UIImage imageNamed:[self.imageArray lastObject]];
                    }else{
                        imageView.image = [self.imageArray lastObject];
                    }
                }else{
                    if ([self.imageArray[self.currentImageIndex -1] isKindOfClass:[NSString class]]) {
                        imageView.image = [UIImage imageNamed:self.imageArray[self.currentImageIndex -1]];
                    }else{
                        imageView.image = self.imageArray[self.currentImageIndex -1];
                    }
                }
            }else{
                if (self.currentImageIndex == self.imageArray.count-1) {
                    if ([self.imageArray[0] isKindOfClass:[NSString class]]) {
                        imageView.image = [UIImage imageNamed:self.imageArray[0]];
                    }else{
                        imageView.image = self.imageArray[0];
                    }

                }else{
                    if ([self.imageArray[self.currentImageIndex+1] isKindOfClass:[NSString class]]) {
                        imageView.image = [UIImage imageNamed:self.imageArray[self.currentImageIndex+1]];
                    }else{
                        imageView.image = self.imageArray[self.currentImageIndex+1];
                    }
                }
            }
        }
        [_scrollView addSubview:imageView];
    }
    
}
- (void)createMineBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2*self.view.frame.size.width/3, self.view.frame.size.height-44, self.view.frame.size.width/3, 44);
    [btn setTitle:@" 赞" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"photo_like.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:btn];
}
#pragma mark 图片转换
- (void)changeImage:(NSInteger)currtenIndex
{
    //提取imageView
    UIImageView* imageView = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 0];
    UIImageView* imageView1 = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 1];
    UIImageView* imageView2 = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 2];
    
    
    id image;
    id image2;
    id image3;
    //三种情况转换imageView上的图片
    if (currtenIndex == _imageArray.count-1) {
        image = self.imageArray[self.currentImageIndex];
        image2 = self.imageArray[0];
        image3 = self.imageArray[self.currentImageIndex-1];
        
    }else if (currtenIndex == 0){
        image = self.imageArray[self.currentImageIndex];
        image2 = self.imageArray[self.currentImageIndex+1];
        image3 = [self.imageArray lastObject];
    }else{
        image = self.imageArray[self.currentImageIndex];
        image2 = self.imageArray[self.currentImageIndex+1];
        image3 = self.imageArray[self.currentImageIndex-1];
    }
    if ([image isKindOfClass:[NSString class]]) {
        imageView1.image = [UIImage imageNamed:image];
    }else{
        imageView1.image = image;
    }
    if ([image2 isKindOfClass:[NSString class]]) {
        imageView2.image = [UIImage imageNamed:image2];
    }else{
        imageView2.image = image2;
    }
    if ([image3 isKindOfClass:[NSString class]]) {
        imageView.image = [UIImage imageNamed:image3];
    }else{
        imageView.image = image3;
    }
}

#pragma mark UIScrollViewDelegate
//拖拽需要走的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageArray.count > 2) {
        CGPoint scrollViewPoint = _scrollView.contentOffset;
        if (scrollViewPoint.x > self.view.frame.size.width) {
            if (self.currentImageIndex == _imageArray.count - 1) {
                self.currentImageIndex = 0;
            }else{
                self.currentImageIndex ++;
            }
        }else if(scrollViewPoint.x < self.view.frame.size.width){
            if (self.currentImageIndex == 0) {
                self.currentImageIndex = _imageArray.count-1;
            }else{
                self.currentImageIndex --;
            }
        }
        //始终显示中间那张imageView
        [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, -64) animated:NO];
        [self changeImage:self.currentImageIndex];//调整图片
    }else{
        self.currentImageIndex = _scrollView.contentOffset.x / self.view.frame.size.width;
    }
}

#pragma mark 时间
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
