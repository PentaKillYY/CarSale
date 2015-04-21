//
//  DXSemiViewControllerCategory.m
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import "DXSemiViewControllerCategory.h"
#import "DXImageViewController.h"
#import "DXMasterViewController.h"
@implementation UIViewController (SemiViewController)

@dynamic leftSemiViewController;
@dynamic rightSemiViewController;
@dynamic leftMasterSemiViewController;
@dynamic rightMasterSemiViewController;

- (void)setLeftSemiViewController:(DXImageViewController *)semiLeftVC Title:(id)caritem
{
    [self setSemiViewController:semiLeftVC withDirection:SemiViewControllerDirectionLeft Title:caritem];
}

- (void)setRightSemiViewController:(DXImageViewController *)semiRightVC Title:(id)caritem
{
    [self setSemiViewController:semiRightVC withDirection:SemiViewControllerDirectionRight Title:caritem];
}

- (void)setSemiViewController:(DXImageViewController *)semiVC withDirection:(SemiViewControllerDirection)direction Title:(id)caritem
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

- (void)setMasterRightSemiViewController:(DXMasterViewController *)semiRightMaster Title:(id)menuitem{
    [self setMasterSemiViewController:semiRightMaster withDirection:SemiMasterDirectionRight Title:menuitem];
}

- (void)setMasterLeftSemiViewController:(DXMasterViewController *)semiLeftMaster Title:(id)menuitem
{
    [self setMasterSemiViewController:semiLeftMaster withDirection:SemiMasterDirectionLeft Title:menuitem];
}

- (void)setMasterSemiViewController:(DXMasterViewController *)semiMaster withDirection:(SemiMasterDirection)direction Title:(id)menuitem
{
    semiMaster.direction = direction;
    CGRect selfFrame = self.view.bounds;
    switch (direction) {
        case SemiViewControllerDirectionRight:
            selfFrame.origin.x += selfFrame.size.width;
            break;
        case SemiViewControllerDirectionLeft:
            selfFrame.origin.x -= selfFrame.size.width;
            break;
    }
    semiMaster.view.frame = selfFrame;
    
    [semiMaster setDetailItem:menuitem];
    // 更新界面
    [self.view addSubview:semiMaster.view];
    [self addChildViewController:semiMaster];
    [semiMaster willMoveToParentViewController:self];
}
@end