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
@interface MoreCarInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView reloadData];
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

#pragma mark -TableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
