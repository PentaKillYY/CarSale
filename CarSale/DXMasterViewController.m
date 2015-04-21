//
//  DXSemiViewController.m
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import "DXMasterViewController.h"

@interface DXMasterViewController ()
@property(nonatomic,retain)NSArray* dataSourceArray;
@property (retain,nonatomic)UILabel* label;

@end

@implementation DXMasterViewController
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

-(void)configureView{

    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        sleep(1);
        [[SearchFromDBHandler sharedSearchHandler] getCarNameFromDataBaseWhere:[_detailItem description] OnSuccess:^(NSArray *array) {
            self.dataSourceArray = [NSArray arrayWithArray:array];
            // 更新界面
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
            [self.tableView reloadData];
        });
    });    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sideAnimationDuration = 0.5f;
    self.sideOffset = 50.0f;
    self.view.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    UIView *anotherView = [[UIView alloc] init];
    anotherView.backgroundColor = [UIColor clearColor];
    anotherView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSemi:)];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSemi:)];
    
    CGRect selfViewFrame = self.view.bounds;
            selfViewFrame.size.width = CGRectGetWidth(selfViewFrame) - self.sideOffset;
    selfViewFrame.origin.x = self.sideOffset;
    self.contentView.frame = selfViewFrame;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.contentView layer].shadowPath =[UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    self.contentView.layer.shadowOffset = CGSizeMake(-10, 0);
    self.contentView.layer.shadowOpacity = 0.90;

    selfViewFrame.origin.x = CGRectGetMinX(self.view.bounds);
    selfViewFrame.size.width = self.sideOffset;
    anotherView.frame = selfViewFrame;
        
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:anotherView];
    [anotherView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        CGRect selfViewFrame = self.view.frame;
        selfViewFrame.origin.x = 0.0f;
        self.view.frame = selfViewFrame;
    } completion:^(BOOL finished) {
        [super willMoveToParentViewController:parent];
    }];
}

- (void)dismissSemi:(id)sender
{
    [self willMoveToParentViewController:nil];
    CGRect pareViewRect = self.parentViewController.view.bounds;
    CGFloat originX = 0;

    switch (self.direction) {
        case SemiMasterDirectionLeft:
            originX -= CGRectGetWidth(pareViewRect);
            break;
        case SemiMasterDirectionRight:
            originX += CGRectGetWidth(pareViewRect);
    }
    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        self.view.frame = CGRectMake(originX, CGRectGetMinY(pareViewRect), CGRectGetWidth(pareViewRect), CGRectGetHeight(pareViewRect));
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    [self removeFromParentViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewdataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%d",self.dataSourceArray.count);
    
    if (self.dataSourceArray) {
        return self.dataSourceArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DxCell"];
    cell.tag = 1;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DxCell"];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!self.dataSourceArray) {
        MainSectionview* sectionView = [[MainSectionview alloc] init];
        return (UITableViewHeaderFooterView*)sectionView;
    }else{
        MainSectionview* sectionView = [[MainSectionview alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
        [sectionView awakeFromNib];
        sectionView.SelectedDelegate = self;
        sectionView.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DXMenu.png"]];
        sectionView.label.textColor = [UIColor blackColor];
        sectionView.label.text = [_detailItem description];
        return (UITableViewHeaderFooterView*)sectionView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}

-(void)shouldChangeRow:(NSInteger)sectionNumber {
   
}



@end
