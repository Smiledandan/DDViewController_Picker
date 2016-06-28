//
//  DDViewController_Picker.h
//  Demo_GetAllPhotos
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DDTableViewController_List.h"

@protocol DDControllerPickerDelegate

/***  image 原始尺寸图片;*/
- (void)DDgetSeletedImageFromImages:(NSArray *)images Targat:(UIViewController *)Controller;

- (void)DDgetCameraImageFrom:(UIImage *)image  Targat:(UIViewController *)Controller;
//暂时弃用;  用来直接 present DDViewController_Picker时候的取消;   
//- (void)DDCancelTargat:(UIViewController *)Controller;

@end

@interface DDViewController_Picker : UIViewController

/***  最大选择图片数量;     default = 3;*/
@property (nonatomic, assign)NSInteger maxSelection;
@property (nonatomic, assign) id <DDControllerPickerDelegate> delegateDD;
@property (nonatomic, assign) ALAssetsGroupType type;
@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, assign) photoType photoType;

@property (nonatomic, strong) UIViewController *controller_root;

@end
