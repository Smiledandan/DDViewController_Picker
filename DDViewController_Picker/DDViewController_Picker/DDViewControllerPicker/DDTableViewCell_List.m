//
//  DDTableViewCell_List.m
//  DDViewController_Picker
//
//  Created by Smile on 16/4/1.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "DDTableViewCell_List.h"

@implementation DDTableViewCell_List

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)getDDTableViewCell_List{
    return [[NSBundle mainBundle] loadNibNamed:@"DDTableViewCell_List" owner:nil options:nil].lastObject;
}

@end
