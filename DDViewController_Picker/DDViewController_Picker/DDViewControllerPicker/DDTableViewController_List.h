//
//  DDTableViewController_List.h
//  DDViewController_Picker
//
//  Created by Smile on 16/4/1.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, photoType) {
    photoType_Max = 0,
    photoType_Min = 1,
};

@interface DDTableViewController_List : UITableViewController

/**
 *  务必赋值;  用来使用导航直接 push 到此 ListVC后 pop回主 ViewControl;
 */
@property (nonatomic, strong) UIViewController *controller_root;
@property (nonatomic, assign)NSInteger maxSelection;

@property (nonatomic, assign) photoType photoType;

@end
