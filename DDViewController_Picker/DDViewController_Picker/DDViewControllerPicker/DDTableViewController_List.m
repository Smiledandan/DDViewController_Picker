//
//  DDTableViewController_List.m
//  DDViewController_Picker
//
//  Created by Smile on 16/4/1.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "DDTableViewController_List.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DDTableViewCell_List.h"
#import "DDViewController_Picker.h"
static NSString *cellIdentifier = @"DDTableViewCell_List";

@interface DDTableViewController_List () <DDControllerPickerDelegate> {
    ALAssetsLibrary *_assetsLibrary;
    NSMutableArray *_groupArr;
    DDViewController_Picker *_photoListVC;
    
}
@end

@implementation DDTableViewController_List

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _groupArr = [NSMutableArray new];
    [self.tableView registerClass:[DDTableViewCell_List class] forCellReuseIdentifier:cellIdentifier];
    [self getList];
}
/**获取相册列表*/
- (void)getList{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    // 枚举回调
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            // 设置过滤类型
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [_groupArr addObject:group];
        } else {
            // group为nil时代表枚举完成 刷新tableView
            [self.tableView reloadData];
        }
    };
    
    // 枚举失败回调
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSLog(@"没有权限访问相册");
    };
    
    // 设置枚举相簿类型
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos;
    
    [library enumerateGroupsWithTypes:type usingBlock:resultsBlock failureBlock:failureBlock];
}

/**获取某个相簿最后一张图片*/
- (void)getLastImageByGroup:(ALAssetsGroup *)group usingBlock:(void (^)(UIImage *image))block {
    // 枚举回调
    void (^selectionBlock)(ALAsset *,NSUInteger,BOOL*) = ^(ALAsset* asset,NSUInteger index, BOOL *innerStop) {
        if (asset == nil) {
            return;
        }
        if (block) {
            block([UIImage imageWithCGImage:[asset thumbnail]]);
        }
    };
    
    // 设置过滤类型
    [group  setAssetsFilter:[ALAssetsFilter allPhotos]];
    if ([group numberOfAssets] >0 ) {
        NSUInteger index             = [group numberOfAssets] - 1;
        NSIndexSet *lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index];
        // 枚举最后一个Asset
        [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:selectionBlock];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewCell_List *cell = [DDTableViewCell_List getDDTableViewCell_List];
    // Configure the cell...
    ALAssetsGroup *group = _groupArr[indexPath.row];
    [self getLastImageByGroup:group usingBlock:^(UIImage *image) {
        cell.imageView_Icon.image = image;
    }];
    
    cell.lab_Name.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.lab_Images_Count.text = [NSString stringWithFormat:@"共%zd张",[group numberOfAssets]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_groupArr[indexPath.row] numberOfAssets] == 0) {
//        [SVProgressHUD showErrorWithStatus:@"此相簿没有照片" duration:1.0f];
        NSLog(@"此相簿没有照片");
        return;
    }
    
    _photoListVC = [DDViewController_Picker new];
    _photoListVC.delegateDD = _controller_root;
    _photoListVC.maxSelection = _maxSelection;
    _photoListVC.controller_root = _controller_root;
    _photoListVC.group = _groupArr[indexPath.row];
    _photoListVC.navigationItem.title = [_groupArr[indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
    [self.navigationController pushViewController:_photoListVC animated:YES];
}

#pragma mark  DDViewController_Picker Delegate;
- (void)DDgetSeletedImageFromImages:(NSArray *)array_OriginalImage Targat:(UIViewController *)Controller{
    [Controller.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -2] animated:YES];
    
}

- (void)DDgetCameraImageFrom:(UIImage *)image  Targat:(UIViewController *)Controller{
    [Controller.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -2] animated:YES];
    
}

- (void)DDCancelTargat:(UIViewController *)Controller{
    [Controller.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
