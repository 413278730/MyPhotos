//
//  ViewController.m
//  MyPhotos
//
//  Created by 邓金龙 on 15/12/21.
//  Copyright © 2015年 邓金龙. All rights reserved.
//

#import "ViewController.h"
#import "MyPhotosViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController
{
    NSMutableArray* _dataSouce;
    NSMutableArray* _titleArray;
    UICollectionView* _collectionView;
    BOOL _isEdit;//表示当前状态。yes为编辑状态， no为普通状态
    NSMutableArray* _delegateImageArray;//删除图片的数组
    UIButton* _changeBtn;//编辑按钮
    UILabel* _numberImageLabel;//显示选中多少张图片
    UIView* _editView;//编辑状态背景图
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNav];
    //初始化数据源
    [self createSource];
    //设置UI
    [self createUI];
    //创建编辑框
    [self createOtherUI];
    
}
#pragma mark 功能
- (void)hiddenEditView
{
    [UIView animateWithDuration:0.3 animations:^{
        _editView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44);
    }];
}
- (void)showEditView
{
    [UIView animateWithDuration:0.3 animations:^{
        _editView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    }];
}
//将所有图片上的选中图片去掉
- (void)deleteAllSelectImageView
{
    for (int i = 0; i < _dataSouce.count; i ++) {
        NSArray* array = _dataSouce[i];
        for (int j = 0; j < array.count; j ++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i+1];
            UICollectionViewCell* cell = [_collectionView cellForItemAtIndexPath:indexPath];
            //如果能查找到选中的图片，就不需要再次选中
            for (UIView* view in cell.subviews) {
                if ([view isMemberOfClass:[UIImageView class]]) {
                    UIImageView* imageView = (UIImageView*)view;
                    if ([imageView.image isEqual:[UIImage imageNamed:@"album_choose_photos.png"]]) {
                        [imageView removeFromSuperview];
                        break;
                    }
                }
            }

        }
    }
}
#pragma mark 事件
- (void)changeAction
{
    //切换按钮的标题
    if ([_changeBtn.titleLabel.text isEqualToString:@"编辑"]) {
        _isEdit = YES;//把状态改为编辑状态
        [_changeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self showEditView];//显示编辑栏
    }else{
        _isEdit = NO;//把状态改为普通状态
        [_changeBtn setTitle:@"编辑" forState:UIControlStateNormal];

        [self hiddenEditView];//隐藏编辑栏
        if (_delegateImageArray.count > 0) {
            //将所有图片上的选中图片去掉
            [self deleteAllSelectImageView];
            [_delegateImageArray removeAllObjects];
            _numberImageLabel.text = [NSString stringWithFormat:@"共选中0张图片"];
        }
    }
}
/**
 *  全选
 */
- (void)allAction
{
    for (int i = 0; i < _dataSouce.count; i ++) {
        NSArray* array = _dataSouce[i];
        for (int j = 0; j < array.count; j ++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i+1];
            UICollectionViewCell* cell = [_collectionView cellForItemAtIndexPath:indexPath];
            BOOL breakNumber = NO;
            //如果能查找到选中的图片，就不需要再次选中
            for (UIView* view in cell.subviews) {
                if ([view isMemberOfClass:[UIImageView class]]) {
                    UIImageView* imageView = (UIImageView*)view;
                    if ([imageView.image isEqual:[UIImage imageNamed:@"album_choose_photos.png"]]) {
                        breakNumber = YES;
                        break;
                    }
                }
            }
            //上面的循环不能直接让真个循环进入下一次，所以要用这种方式来进入下一次循环
            if (breakNumber == YES) {
                continue;
            }
            //选中
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(91-27, 5, 24, 24)];
            imageView.image = [UIImage imageNamed:@"album_choose_photos.png"];
            [cell addSubview:imageView];
            [_delegateImageArray addObject:_dataSouce[i][j]];
            _numberImageLabel.text = [NSString stringWithFormat:@"共选中%ld张图片",_delegateImageArray.count];
        }
    }
}
/**
 *  删除
 */
- (void)delegateAction
{
    for (int i = 0; i < _delegateImageArray.count; i ++) {
        id delegateString = _delegateImageArray[i];
        for (int n = 0; n < _dataSouce.count; n ++) {
            NSMutableArray* array = [_dataSouce[n] mutableCopy];
            for (int m = 0; m < array.count; m ++) {
                if ([array[m] isKindOfClass:[NSString class]] && [delegateString isKindOfClass:[NSString class]]) {
                    if ([(NSString*)delegateString isEqualToString:array[m]]) {
                        [array removeObject:delegateString];
                        [_dataSouce replaceObjectAtIndex:n withObject:array];
                        if (array.count == 0) {
                            [_dataSouce removeObjectAtIndex:n];
                            [_titleArray removeObjectAtIndex:n];
                        }
                        break;
                    }
                }else if([array[m] isKindOfClass:[UIImage class]] && [delegateString isKindOfClass:[UIImage class]]){
                    if ([(UIImage*)delegateString isEqual:array[m]]) {
                        [array removeObject:delegateString];
                        [_dataSouce replaceObjectAtIndex:n withObject:array];
                        if (array.count == 0) {
                            [_dataSouce removeObjectAtIndex:n];
                            [_titleArray removeObjectAtIndex:n];
                        }
                        break;
                    }
                }
            }
        }
    }
    [_collectionView reloadData];
}

#pragma mark 设置导航栏
- (void)setNav
{
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeBtn setFrame:CGRectMake(0, 0, 60, 30)];
    [_changeBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [_changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    UIBarButtonItem* barBtn = [[UIBarButtonItem alloc] initWithCustomView:_changeBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
}
#pragma mark 创建UI
//创建collectionView
- (void)createUI
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(91, 91);
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 1, 12, 1);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photoListCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [self.view addSubview:_collectionView];
    
}
//创建编辑工具栏视图
- (void)createOtherUI
{
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, 44)];
    _editView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_editView];
    //全选按钮
    UIButton* allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(12, 0, 50, 44);
    [allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    [allBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_editView addSubview:allBtn];
    //选中图片
    _numberImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 0, 100, 44)];
    _numberImageLabel.text = @"共选中0张图片";
    _numberImageLabel.textColor = [UIColor blackColor];
    _numberImageLabel.font = [UIFont systemFontOfSize:15];
    [_editView addSubview:_numberImageLabel];
    
    //删除按钮
    UIButton* delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delegateBtn.frame = CGRectMake(self.view.frame.size.width-12-18, 10, 18, 24);
    [delegateBtn setImage:[UIImage imageNamed:@"album_delete_photos.png"] forState:UIControlStateNormal];
    [delegateBtn addTarget:self action:@selector(delegateAction) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:delegateBtn];
}
#pragma mark 初始化数据源
- (void)createSource
{
    _delegateImageArray = [[NSMutableArray alloc] init];
    
    _titleArray = [[NSMutableArray alloc] initWithArray:@[@"2015-12-20 21:30",@"2015-12-16 21:30",@"2015-12-11 21:30",@"2015-12-01 21:30"]];
    
    _dataSouce = [[NSMutableArray alloc] initWithArray:@[@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"],@[@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg"],@[@"10.jpg",@"11.jpg"],@[@"12.jpg",@"13.jpg",@"14.jpg"]]];
    
}
#pragma mark UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSouce.count +1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [_dataSouce[section-1] count];
    }
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoListCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 91, 91)];
        imageView.image = [UIImage imageNamed:@"album_add_photos.png"];
        [cell addSubview:imageView];
    }else{
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 91, 91)];
        if ([_dataSouce[indexPath.section-1][indexPath.row] isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:_dataSouce[indexPath.section-1][indexPath.row]];
        }else{
            imageView.image = _dataSouce[indexPath.section-1][indexPath.row];
        }
        [cell addSubview:imageView];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.type == isMyPhotoList && section == 0) {
        CGSize size = {0, 0};
        return size;
    }else{
        if ([_dataSouce[section -1] count] == 0) {
            CGSize size = {0.01, 0.01};
            return size;
        }
        CGSize size = {self.view.frame.size.width, 20};
        return size;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        for (UIView* subView in view.subviews) {
            if ([subView isMemberOfClass:[UILabel class]]) {
                [subView removeFromSuperview];
            }
        }
        if ([_dataSouce[indexPath.section -1] count] == 0) {
            return nil;
        }
        NSString* titleString = [NSString stringWithFormat:@"  %@",_titleArray[indexPath.section-1]];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        titleLabel.text = titleString;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:titleLabel];
        return view;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEdit == YES) {
        if (indexPath.section == 0) {
            return;
        }
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        //如果能查找到选中的图片，说明是第二次选中，就可以移除
        for (UIView* view in cell.subviews) {
            if ([view isMemberOfClass:[UIImageView class]]) {
                UIImageView* imageView = (UIImageView*)view;
                if ([imageView.image isEqual:[UIImage imageNamed:@"album_choose_photos.png"]]) {
                    [imageView removeFromSuperview];
                    id imageTitle = _dataSouce[indexPath.section-1][indexPath.row];
                    for (id delegateImageTitle in _delegateImageArray) {
                        if ([delegateImageTitle isKindOfClass:[NSString class]]) {
                            if ([(NSString*)delegateImageTitle isEqualToString:imageTitle]) {
                                //将要删除的照片从数组内删除
                                [_delegateImageArray removeObject:delegateImageTitle];
                                _numberImageLabel.text = [NSString stringWithFormat:@"共选中%ld张图片",_delegateImageArray.count];
                                return;
                            }
                        }else{
                            if([(UIImage*)delegateImageTitle isEqual:imageTitle]){
                                //将要删除的照片从数组内删除
                                [_delegateImageArray removeObject:delegateImageTitle];
                                _numberImageLabel.text = [NSString stringWithFormat:@"共选中%ld张图片",_delegateImageArray.count];
                                return;
                            }
                        }
                    }
                }
            }
        }
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(91-27, 5, 24, 24)];
        imageView.image = [UIImage imageNamed:@"album_choose_photos.png"];
        [cell addSubview:imageView];
       
        [_delegateImageArray addObject:_dataSouce[indexPath.section-1][indexPath.row]];

        _numberImageLabel.text = [NSString stringWithFormat:@"共选中%ld张图片",_delegateImageArray.count];
    }else{
        if (indexPath.section == 0) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
            [actionSheet showInView:self.view];
        }else{
            MyPhotosViewController* myPhotoVC = [[MyPhotosViewController alloc] init];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            for (int i = 0; i < _dataSouce.count; i ++) {
                NSArray* subArray = _dataSouce[i];
                for (int j = 0; j < subArray.count; j ++) {
                    [array addObject:subArray[j]];
                    if (i == indexPath.section-1 && j == indexPath.row) {
                        myPhotoVC.currentImageIndex = array.count -1;
                    }
                }
            }
            myPhotoVC.imageArray = [array copy];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:myPhotoVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        //调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            
            NSLog(@"相机不可用");
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDate* data = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* timeString = [formatter stringFromDate:data];
    for (int i = 0; i < _titleArray.count; i ++) {
        NSString* title = _titleArray[i];
        if ([title isEqualToString:timeString]) {
            NSMutableArray* array = [_dataSouce[i] mutableCopy];
            [array insertObject:image atIndex:0];
            [_dataSouce replaceObjectAtIndex:i withObject:array];
            [_collectionView reloadData];
            return;
        }
    }
    [_titleArray insertObject:timeString atIndex:0];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array insertObject:image atIndex:0];
    [_dataSouce insertObject:array atIndex:0];
    [_collectionView reloadData];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
