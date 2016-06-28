//
//  DDTableViewCell_List.h
//  DDViewController_Picker
//
//  Created by Smile on 16/4/1.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTableViewCell_List : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Images_Count;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Icon;

+ (instancetype)getDDTableViewCell_List;



@end
