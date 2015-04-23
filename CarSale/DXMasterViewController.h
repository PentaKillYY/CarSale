//
//  DXSemiViewController.h
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SearchFromDBHandler.h"
#import "UIView+Shadow.h"
#import "MainSectionview.h"

typedef enum {
    SemiMasterDirectionLeft,
    SemiMasterDirectionRight,
}SemiMasterDirection;


@interface DXMasterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) SemiMasterDirection direction;
@property (nonatomic, assign) CGFloat sideAnimationDuration;
@property (nonatomic, assign) CGFloat sideOffset;

@property (nonatomic, strong)IBOutlet UIView *contentView;
@property (nonatomic, strong)IBOutlet UITableView* tableView;
@property (strong, nonatomic) id detailItem;

- (void)dismissSemi:(id)sender;

@end
