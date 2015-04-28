//
//  MoreCarInfoViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "MoreCarInfoViewController.h"
#import "UIView+Shadow.h"
#import <MBProgressHUD.h>
#import "XCMultiSortTableView.h"

@interface MoreCarInfoViewController ()<UITableViewDataSource,UITableViewDelegate,XCMultiTableViewDataSource>
{
    XCMultiTableView * xcMultiTableView;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}
@property (strong,nonatomic)IBOutlet UITableView* tableView;
@property (retain,nonatomic)UILabel* label;
@end

@implementation MoreCarInfoViewController
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            sleep(1);
            self.carDic = [NSDictionary dictionaryWithDictionary:(NSDictionary*)_detailItem];
            [self prepareCarInfoDataSource:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView reloadData];
                [self setCarInfoGridView];
            });
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加导航栏退回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = backItem;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = YES;
    [self setExtraCellLineHidden];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.carDic) {
        return [[[[[self.carDic objectForKey:@"carinfo"]objectForKey:@"CarInfo"] objectAtIndex:0]objectForKey:@"Parameter"] count];
    }
    return 0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarInfoCell" forIndexPath:indexPath];
    cell.tag = 1;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarInfoCell"];
    }else{
        for(UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (self.carDic) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 50)];
        self.label.text = [[[[[[[self.carDic objectForKey:@"carinfo"]objectForKey:@"CarInfo"]objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];;
        self.label.textColor = [UIColor whiteColor];
        UIImageView* bgView = [[UIImageView alloc] initWithFrame:cell.frame];
        
        [bgView setImage:[UIImage imageNamed:@"Menu.png"]];
        [bgView makeInsetShadowWithRadius:5.0 Color:[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:0.8] Directions:[NSArray arrayWithObjects:@"top", nil]];
        
        UIImageView* selectedBGView = [[UIImageView alloc] initWithFrame:cell.frame];
        [selectedBGView setImage:[UIImage imageNamed:@"MenuSelected.png"]];
        [selectedBGView makeInsetShadowWithRadius:5.0 Color:[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:0.8] Directions:[NSArray arrayWithObjects:@"top", nil]];
        cell.backgroundView = (UIView*)bgView;
        cell.selectedBackgroundView = (UIView*)selectedBGView;
        [cell.contentView addSubview:self.label];
    }
    
    return cell;
}

#pragma mark -TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [self prepareCarInfoDataSource:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self setCarInfoGridView];
        });
    });
}

#pragma mark - CarInfoDataPrepare

-(void)prepareCarInfoDataSource:(NSInteger)index{
    NSArray* carParameterArray = [[self.carDic objectForKey:@"carinfo"] objectForKey:@"CarInfo"];
    NSInteger headCount = [carParameterArray count];
    
    NSInteger leftCount = [[[[[[carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:index] allValues]objectAtIndex:0] allKeys].count;
    NSInteger rightCount = [[[[[[carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:index] allValues]objectAtIndex:0] allValues].count;
    //------添加车名源--------------------------------------
    headData = [NSMutableArray arrayWithCapacity:headCount];
    
    for (NSDictionary* car in carParameterArray) {
        [headData addObject:[car objectForKey:@"CarName"]];
    }
    //------添加参数名源
    leftTableData = [NSMutableArray arrayWithCapacity:leftCount];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:leftCount];
    for (NSString* string in [[[[[[carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:index] allValues]objectAtIndex:0] allKeys]) {
        [one addObject:string];
    }
    [leftTableData addObject:one];

    //------添加参数值源
    rightTableData = [NSMutableArray arrayWithCapacity:rightCount];
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:rightCount];
    for (int i = 0; i < leftCount; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:rightCount];
        for (int k = 0; k < headCount; k++) {
            [ary addObject:[[[[[[[carParameterArray objectAtIndex:k] objectForKey:@"Parameter"] objectAtIndex:index] allValues]objectAtIndex:0] allValues] objectAtIndex:i]];
        }
        
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
}

-(void)setCarInfoGridView{
    if (xcMultiTableView) {
        [xcMultiTableView removeFromSuperview];
    }
    CGFloat width;
    CGFloat height;
    if (100 * headData.count > 374) {
        width = 374.0f;
    }else{
        width =100.0f * headData.count;
    }
    if (60*leftTableData.count > 644) {
        height = 644.0f;
    }else{
        height = 644.0f;
    }
    
    xcMultiTableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(CGRectMake(320, 64, width+100, height+60), 5.0f, 5.0f)];
    xcMultiTableView.leftHeaderEnable = YES;
    xcMultiTableView.datasource = self;
    
    [self.view addSubview:xcMultiTableView];
    [xcMultiTableView reloadData];
    
}


#pragma mark - XCMultiTableViewDataSource

- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    return 100.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {        return 60.0f;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    return [UIColor grayColor];
}


#pragma mark -NavAction
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}


@end
