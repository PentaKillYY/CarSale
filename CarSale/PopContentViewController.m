//
//  PopContentViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-28.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "PopContentViewController.h"

@interface PopContentViewController ()
@property(nonatomic,retain)NSMutableArray* contentArray;
@end

@implementation PopContentViewController
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        self.contentArray = [NSMutableArray arrayWithArray:(NSArray*)_detailItem];
        self.view.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.x, 200, self.contentArray.count*self.tableView.rowHeight);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setExtraCellLineHidden];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    cell.tag = 1;
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCell"];
    }else{
        for(UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate cellDidSelect:[self.contentArray objectAtIndex:indexPath.row]];
}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}
@end
