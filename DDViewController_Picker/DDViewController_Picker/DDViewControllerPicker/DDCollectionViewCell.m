//
//  CollectionViewCell.m
//  Demo_GetAllPhotos
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "DDCollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setIs_Selected:(BOOL)is_Selected{
    _is_Selected = is_Selected;
    _view_Mask.hidden = ! _is_Selected;
    _imageView_Select.hidden = _view_Mask.hidden;
}


@end
