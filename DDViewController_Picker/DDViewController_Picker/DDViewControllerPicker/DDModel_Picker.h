//
//  DDModel_Picker.h
//  Demo_GetAllPhotos
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface DDModel_Picker : NSObject



/**
 *  是否选中某张图;
 */
@property (nonatomic, assign) BOOL isSelection;

/**
 *  cell 展示的图片;
 */
@property (nonatomic, assign) UIImage *image_Cellimage;

/**
 *  位置;
 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ALAsset *asset;

@end
