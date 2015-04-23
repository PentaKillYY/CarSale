//
//  MasterViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-19.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "MasterViewController.h"
#import "MainSectionview.h"
#import "AppDefine.h"
#import "SearchFromDBHandler.h"
#import "SecondMasterTableViewController.h"
#import "DXMasterViewController.h"
#import "UIView+Shadow.h"
#import "UpdateHandler.h"
#import <MBProgressHUD.h>
#import "URBAlertView.h"
#import "LaunchViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "DXSemiViewControllerCategory.h"
#import "DetailViewController.h"
@interface MasterViewController ()<UITableViewDataSource,UITableViewDelegate,ContentSlected>

@property NSMutableArray *objects;
@property NSMutableArray* rowOfSectionArr;
@property NSMutableArray* openedInSectionArr;
@property (strong,nonatomic)IBOutlet UITableView* tableView;
@property (retain,nonatomic)NSArray* dataAry;
@property (retain,nonatomic)UILabel* label;
@property (strong,nonatomic)IBOutlet UIImageView* logoView;
@property (nonatomic, strong) URBAlertView *alertView;
@end

@implementation MasterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    self.rowOfSectionArr = [[NSMutableArray alloc] init];
    self.openedInSectionArr = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDataVersion)];
    [self.logoView addGestureRecognizer:tap];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [[SearchFromDBHandler sharedSearchHandler] getMenuFromDataBase:^(NSArray *array) {
            self.dataAry = [NSArray arrayWithArray:array];
            for (int i = 0; i < [self.dataAry count]; i++) {
                [self.rowOfSectionArr addObject:@([[[self.dataAry objectAtIndex:i] objectAtIndex:1] count])];
                [self.openedInSectionArr addObject:@"0"];
            }
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.tableView reloadData];
        });
    });

    
    [self setExtraCellLineHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.navigationController.navigationBar.hidden = YES;
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"检测到新版本"
                                                          message:@"是否更新至最新版本"
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles: @"确定", nil];
    
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        if (buttonIndex == 1) {
            UIStoryboard  * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LaunchViewController* launch = (LaunchViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"Launch"];
            self.splitViewController.view.window.rootViewController = launch;
        }
        [self.alertView hideWithCompletionBlock:^{
            // stub
        }];
    }];
    
    self.alertView = alertView;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"PushToSecond"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        SecondMasterTableViewController* secondMaster = (SecondMasterTableViewController*)[segue destinationViewController];
//        [secondMaster setSelectedItem:[[[self.dataAry objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
//    }
    if ([[segue identifier] isEqualToString:@"masterChange"]) {
        UITableViewCell *cell=(id)sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        DetailViewController* detail = (DetailViewController*)[segue destinationViewController];
        [detail setDetailItem:@{@"Menu":[[[self.dataAry objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]}];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataAry.count == 0) {
        return 0;
    }
    return [self.dataAry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.openedInSectionArr.count == 0) {
        return 0;
    }else if ([[self.openedInSectionArr objectAtIndex:section] intValue] == 1) {
        return [[self.rowOfSectionArr objectAtIndex:section] intValue];
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = 1;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }else{
        for(UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 50)];
    self.label.text = [[[self.dataAry objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MainSectionview* sectionView = [[MainSectionview alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [sectionView awakeFromNib];
    sectionView.SelectedDelegate = self;
    sectionView.contentView.tag = 100+section;
    if ([[self.openedInSectionArr objectAtIndex:section] intValue] == 1){
        if (section == 0) {
            sectionView.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TopMenuSelected.png"]];
            sectionView.imageView.image = [UIImage imageNamed:@"styleselected.png"];
        }else{
            sectionView.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MidMenuSelected.png"]];
            sectionView.imageView.image = [UIImage imageNamed:@"priceselected.png"];
        }
        sectionView.label.textColor = [UIColor whiteColor];
    }else{
        if (section == 0) {
            sectionView.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TopMenu.png"]];
            sectionView.imageView.image = [UIImage imageNamed:@"style.png"];
        }else{
            sectionView.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MidMenu.png"]];
            sectionView.imageView.image = [UIImage imageNamed:@"price.png"];
        }
        sectionView.label.textColor = [UIColor blackColor];
    }
    
    sectionView.label.text = [[self.dataAry objectAtIndex:section] objectAtIndex:0];
    return (UITableViewHeaderFooterView*)sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DXMasterViewController* semiMasterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DXMaster"];
    [self setMasterRightSemiViewController:semiMasterViewController Title:[[[self.dataAry objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];

}

-(void)shouldChangeRow:(NSInteger)sectionNumber {
    if ([[self.openedInSectionArr objectAtIndex:sectionNumber - 100] intValue] == 0) {
        [self.openedInSectionArr replaceObjectAtIndex:sectionNumber - 100 withObject:@"1"];
    }
    else
    {
        [self.openedInSectionArr replaceObjectAtIndex:sectionNumber - 100 withObject:@"0"];
    }
    [self.tableView reloadData];
}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}


-(void)checkDataVersion
{
    NSInteger networkStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkStatus <= 0 ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.splitViewController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请检查网络连接";
        hud.yOffset = 27.0f;
        hud.xOffset = 150.f;
        [hud hide:YES afterDelay:2];
    }else{
        [[UpdateHandler sharedUpdateHandler] checkDatabaseVersionOnState:^(BOOL isLatest) {
            if (isLatest) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.splitViewController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已经是最新版本";
                hud.yOffset = 27.0f;
                hud.xOffset = 150.f;
                [hud hide:YES afterDelay:2];
            }else{
                [self.alertView showWithAnimation:URBAlertAnimationDefault];
            }
        }];
    }
    
}
@end
