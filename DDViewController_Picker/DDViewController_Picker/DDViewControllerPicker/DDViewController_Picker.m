//
//  DDViewController_Picker.m
//  Demo_GetAllPhotos
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "DDViewController_Picker.h"
#import "DDCollectionViewCell.h"
#import "DDModel_Picker.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度

#define DDRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(red)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:(alpha)]
#define DDHexAColor(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

@interface DDViewController_Picker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    UIImagePickerController *_imagePickerController;
    NSMutableArray *_dataArr;
    NSMutableDictionary *_dictSelection;
    ALAssetsLibrary *_assetsLibrary;
}


@end

@implementation DDViewController_Picker

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initView];

    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)initData{
    if (_maxSelection == 0) {
        _maxSelection = 3;
    }
    _dictSelection = [NSMutableDictionary new];
    _dataArr = [NSMutableArray new];
    [self getImage];
}
- (void)initView{
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(DDexitAction)];
    self.navigationItem.title = @"请选择图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(DDEnter)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH -8)/4, (SCREEN_WIDTH -8)/4);
    layout.minimumInteritemSpacing =2;
    layout.minimumLineSpacing =2;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:@"DDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
    [self.view addSubview:_collectionView];
}

#pragma mark        左右两个 item 的点击事件;
- (void)DDexitAction{
//    [self.delegateDD DDCancelTargat:self];
}

- (void)DDEnter{
    NSMutableArray *arrTemp = [NSMutableArray new];
    for (NSString  *dictKey in  _dictSelection) {
        DDModel_Picker *model = _dictSelection[dictKey];
        switch (_photoType) {
            case photoType_Max: {
                [arrTemp addObject:[self fullResolutionImageFromALAsset:model.asset]];
                break;
            }
            case photoType_Min: {
                [arrTemp addObject:[self thumbnailResolutionImageFromALAsset:model.asset]];
                break;
            }
        }
    }
    if (arrTemp.count == 0) {
        NSLog(@"没有选择图片");
        return;
    }
    
    [self.delegateDD DDgetSeletedImageFromImages:arrTemp Targat:self];
}


#pragma mark        UICollectionView Delegate  DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.imageView_Select.hidden = YES;
        cell.view_Mask.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"DDCamera"];
        cell.imageViewBackGround.image = image;
        cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.942 blue:0.045 alpha:1.000];
        return cell;
    }
    
    DDModel_Picker *model = _dataArr[indexPath.item -1];
    cell.imageViewBackGround.image = [self thumbnailResolutionImageFromALAsset:model.asset];
    cell.is_Selected = model.isSelection;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        //跳转到相机;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        return;
    }
    
    DDModel_Picker *model = _dataArr[indexPath.item -1];
    if (model.isSelection == NO && _dictSelection.count +1 > _maxSelection) {
        return;
    }
    model.isSelection = ! model.isSelection;
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.is_Selected = model.isSelection;
    if (model.isSelection) {
        [_dictSelection setValue:model forKey:[NSString stringWithFormat:@"%zd",indexPath.item -1]];
    }else{
        [_dictSelection removeObjectForKey:[NSString stringWithFormat:@"%zd",indexPath.item -1]];
    }
}
#pragma mark        imagePickerController delegate;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegateDD DDgetCameraImageFrom:[info objectForKey:@"UIImagePickerControllerOriginalImage"] Targat:self];
    }];
}

#pragma mark        GetAllImagesFormMobel;
//获取相册的所有图片
- (void)getImage{
    if (_group) {
        [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                DDModel_Picker *mod = [DDModel_Picker new];
                mod.isSelection = NO;
                mod.asset = result;
                [_dataArr addObject:mod];
            }else{
                _dataArr = [[NSMutableArray alloc] initWithArray:[[_dataArr reverseObjectEnumerator] allObjects]];
                [_collectionView reloadData];
            }
        }];
        return;
    }
    
    /**如果 Group 不存在 ;则加载所有图片;*/
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:_type usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    DDModel_Picker *mod = [DDModel_Picker new];
                    mod.isSelection = NO;
                    mod.asset = result;
                    [_dataArr addObject:mod];
                }else{
                    _dataArr = [[NSMutableArray alloc] initWithArray:[[_dataArr reverseObjectEnumerator] allObjects]];
                    [_collectionView reloadData];
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"没有获取到图片;Group not found!\n");
    }];

}

/**取得全尺寸图片*/
- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:UIImageOrientationUp];
    return img;
}

/**取得缩略图*/
- (UIImage *)thumbnailResolutionImageFromALAsset:(ALAsset *)asset{
    UIImage *img = [UIImage imageWithCGImage:[asset thumbnail]];
    return img;
}


@end
