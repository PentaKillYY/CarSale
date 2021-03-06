//
//  DXSemiViewControllerCategory.m
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import "DXSemiViewControllerCategory.h"
#import "DXSemiViewController.h"

@implementation UIViewController (SemiViewController)

@dynamic leftSemiViewController;
@dynamic rightSemiViewController;


- (void)setLeftSemiViewController:(DXSemiViewController *)semiLeftVC Title:(id)caritem
{
    [self setSemiViewController:semiLeftVC withDirection:SemiViewControllerDirectionLeft Title:caritem];
}

- (void)setRightSemiViewController:(DXSemiViewController *)semiRightVC Title:(id)caritem
{
    [self setSemiViewController:semiRightVC withDirection:SemiViewControllerDirectionRight Title:caritem];
}

- (void)setSemiViewController:(DXSemiViewController *)semiVC withDirection:(SemiViewControllerDirection)direction Title:(id)caritem
{
    semiVC.direction = direction;
    CGRect selfFrame = self.view.bounds;
    switch (direction) {
        case SemiViewControllerDirectionRight:
            selfFrame.origin.x += selfFrame.size.width;
            break;
        case SemiViewControllerDirectionLeft:
            selfFrame.origin.x -= selfFrame.size.width;
            break;
    }
    semiVC.view.frame = selfFrame;
    
    [semiVC setDetailItem:caritem];
            // 更新界面
    [self.view addSubview:semiVC.view];
    [self addChildViewController:semiVC];
    [semiVC willMoveToParentViewController:self];
}


@end