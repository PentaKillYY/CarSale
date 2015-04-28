//
//  PopContentViewController.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-28.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DidSelectDelegate <NSObject>

-(void)cellDidSelect:(NSString*)cellText;

@end

@interface PopContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) NSString* idString;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (assign,nonatomic) id <DidSelectDelegate>delegate;
@end
