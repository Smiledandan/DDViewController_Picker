//
//  CollectionViewCell.h
//  Demo_GetAllPhotos
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackGround;

/**
 *  蒙版图层
 */
@property (weak, nonatomic) IBOutlet UIView *view_Mask;

/**
 *  选中标识;
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Select;

@property (nonatomic, assign) BOOL is_Selected;


@end
