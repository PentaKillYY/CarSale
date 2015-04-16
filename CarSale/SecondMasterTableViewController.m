//
//  SecondMasterTableViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-2.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "SecondMasterTableViewController.h"
#import "SearchFromDBHandler.h"
#import "DetailViewController.h"
#import "UIView+Shadow.h"
@interface SecondMasterTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSArray* dataSourceArray;
@property (retain,nonatomic)UILabel* label;
@property (weak,nonatomic)IBOutlet UITableView* tableView;
@property (weak,nonatomic)IBOutlet UIImageView* logoView;
@end

@implementation SecondMasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setExtraCellLineHidden];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToMaster)];
    [self.logoView addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedItem:(id)newSelectedItem {
    if (_selectedItem != newSelectedItem) {
        _selectedItem = newSelectedItem;
        [self getDataSource:(NSString*)_selectedItem];
    }
}

- (void)getDataSource:(NSString*)selectedMenuText{
    [[SearchFromDBHandler sharedSearchHandler] getCarNameFromDataBaseWhere:selectedMenuText OnSuccess:^(NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSourceArray = [NSArray arrayWithArray:array];
            [self.tableView reloadData];
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController* detail = (DetailViewController*)[[segue destinationViewController] topViewController];
        [detail setDetailItem:self.dataSourceArray[indexPath.row]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataSourceArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
    cell.tag = 1;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondCell"];
    }else{
        for(UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 50)];
    self.label.text =self.dataSourceArray[indexPath.row];
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
    return cell;
}

-(void)backToMaster{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}
@end
