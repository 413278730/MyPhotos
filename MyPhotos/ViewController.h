//
//  ViewController.h
//  MyPhotos
//
//  Created by 邓金龙 on 15/12/21.
//  Copyright © 2015年 邓金龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    
    isMyPhotoList = 0,
    isOtherPhotoList
    
}PhotoListType;
@interface ViewController : UIViewController
@property (nonatomic,assign) PhotoListType type;


@end

