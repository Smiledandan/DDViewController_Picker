//
//  ViewController.m
//  DDViewController_Picker
//
//  Created by Smile on 16/3/16.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "ViewController.h"

#import "DDViewController_Picker.h"
#import "DDTableViewController_List.h"

@interface ViewController () <DDControllerPickerDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    [self initView];
}

- (void)initView{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选图片" style:UIBarButtonItemStyleDone target:self action:@selector(pushMoreImagesSelected)];
    
    _tableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        view.separatorColor = [UIColor blackColor];
        view.delegate = self;
        view.dataSource = self;
        [view registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellDefault"];
        
        [self.view addSubview:view];
        view;
    });
}

- (void)pushMoreImagesSelected{
    
    DDTableViewController_List *pickerVC = [DDTableViewController_List new];
#warning mark  务必赋值; 用来使用导航 push后;返回当前 VC;
    pickerVC.controller_root = self;
    pickerVC.maxSelection = 5;
#warning mark  DDViewController_Picker返回的全尺寸图片尺寸较大;如果选择过多图片;则内存暴增..
    pickerVC.photoType = photoType_Min;//这里提供了两种;一中是全尺寸图片即原图;  一种是缩略图;  尺寸
    
    /**如果使用push推出则 推出DDViewController_Picker*/
//    [self.navigationController pushViewController:pickerVC animated:YES];
    
    /**如果使用模态推出则 推出导航 rootViewController 为DDViewController_Picker的Nav*/
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:pickerVC] animated:YES completion:^{
        //code;
    }];
}

- (void)initData{
    _dataArr = [NSMutableArray new];
}


#pragma mark  DDViewController_Picker Delegate;
- (void)DDgetSeletedImageFromImages:(NSArray *)images Targat:(UIViewController *)Controller{
    [self dismissViewControllerAnimated:YES completion:^{
        [_dataArr addObjectsFromArray:images];
        [_tableView reloadData];
    }];
    return;
    
    //如果使用导航直接 push 大批选择图片;则按下面写法返回当前 VC:
    [Controller.navigationController popToViewController:self animated:YES];
    [_dataArr addObjectsFromArray:images];
    [_tableView reloadData];
}

- (void)DDgetCameraImageFrom:(UIImage *)image  Targat:(UIViewController *)Controller{
    [self dismissViewControllerAnimated:YES completion:^{
        [_dataArr addObject:image];
        [_tableView reloadData];
    }];
    return;
    
    //如果使用导航直接 push 到选择图片;则按下面写法返回当前 VC:
    [Controller.navigationController popToViewController:self animated:YES];
    [_dataArr addObject:image];
    [_tableView reloadData];
}


#pragma mark  TableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //code;
    UIImage *ddImage = _dataArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDefault"];
    cell.imageView.image = ddImage;
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
