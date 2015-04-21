//
//  DXSemiViewControllerCategory.h
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXImageViewController;
@class DXMasterViewController;

@interface UIViewController (SemiViewController)

@property (nonatomic, strong) DXImageViewController *leftSemiViewController;
@property (nonatomic, strong) DXImageViewController *rightSemiViewController;
@property (nonatomic, strong) DXMasterViewController *leftMasterSemiViewController;
@property (nonatomic, strong) DXMasterViewController *rightMasterSemiViewController;

- (void)setRightSemiViewController:(DXImageViewController *)semiRightVC Title:(id)caritem;
- (void)setLeftSemiViewController:(DXImageViewController *)semiLeftVC Title:(id)caritem;
- (void)setMasterRightSemiViewController:(DXMasterViewController *)semiRightMaster Title:(id)menuitem;
- (void)setMasterLeftSemiViewController:(DXMasterViewController *)semiLeftMaster Title:(id)menuitem;
@end
