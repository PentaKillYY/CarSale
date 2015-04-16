//
//  DXSemiViewController.h
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SemiViewControllerDirectionLeft,
    SemiViewControllerDirectionRight,
}SemiViewControllerDirection;

@interface DXSemiViewController : UIViewController

@property (nonatomic, assign) SemiViewControllerDirection direction;
@property (nonatomic, assign) CGFloat sideAnimationDuration;
@property (nonatomic, assign) CGFloat sideOffset;

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary* carDic;
- (void)dismissSemi:(id)sender;

@end
