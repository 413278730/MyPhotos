//
//  MyPhotosViewController.h
//  MyPhotos
//
//  Created by 邓金龙 on 15/12/21.
//  Copyright © 2015年 邓金龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotosViewController : UIViewController
@property (nonatomic,strong) NSArray* imageArray;
@property (nonatomic,assign) NSInteger currentImageIndex;

@end
