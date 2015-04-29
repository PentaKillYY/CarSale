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
        NSDictionary* dic = (NSDictionary*)_detailItem;
        self.contentArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"Content"]];
        self.idString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ContentId"]];
        self.view.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.x, 200, (self.contentArray.count+1)*self.tableView.rowHeight);
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
    return (self.contentArray.count+1);
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
    if (indexPath.row == 0) {
        if ([self.idString isEqualToString:@"color"]) {
            cell.textLabel.text = @"全部颜色";
        }else{
            cell.textLabel.text = @"全部类型";
        }
        
    }else{
    cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row-1];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate cellDidSelect:cell.textLabel.text Content:self.idString];
}

- (void)setExtraCellLineHidden{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}
@end
