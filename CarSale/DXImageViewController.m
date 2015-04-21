//
//  DXSemiViewController.m
//  DXSemiSideDemo
//
//  Created by 谢 凯伟 on 13-7-7.
//  Copyright (c) 2013年 谢 凯伟. All rights reserved.
//

#import "DXImageViewController.h"
#import "ImageGalleryCell.h"
#import "AllCollectionReusableView.h"
#import "AppDefine.h"
#import <UIImageView+WebCache.h>
#import "ImgShowViewController.h"
#import <MBProgressHUD.h>
@interface DXImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation DXImageViewController
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            sleep(1);
            self.carDic = [NSDictionary dictionaryWithDictionary:(NSDictionary*)_detailItem];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.collectionView reloadData];
            });
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    self.sideAnimationDuration = 0.5f;
    self.sideOffset = 50.0f;

    UIView *anotherView = [[UIView alloc] init];
    anotherView.backgroundColor = [UIColor clearColor];
    anotherView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSemi:)];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSemi:)];
    CGRect selfViewFrame = self.view.bounds;
    
    [self.contentView layer].shadowPath =[UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    self.contentView.layer.shadowOffset = CGSizeMake(-10, 0);
    self.contentView.layer.shadowOpacity = 0.90;
    selfViewFrame.origin.x = CGRectGetMinX(self.view.bounds);
    selfViewFrame.size.width = self.sideOffset;
    anotherView.frame = selfViewFrame;
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addSubview:anotherView];
    [anotherView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{    
    [UIView animateWithDuration:self.sideAnimationDuration animations:^{
        CGRect selfViewFrame = self.view.frame;
        selfViewFrame.origin.x = 0;
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
        case SemiViewControllerDirectionLeft:
            originX -= CGRectGetWidth(pareViewRect);
            break;
        case SemiViewControllerDirectionRight:
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


#pragma CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.carDic) {
        return [[[self.carDic objectForKey:@"imageArray"] objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]]count];
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        AllCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AllCollection" forIndexPath:indexPath];
        if (self.carDic) {
            headerView.titleLabel.text = [self.carDic objectForKey:@"titlename"];
        }else{
            headerView.titleLabel.text = [NSString stringWithFormat:@"0 张"];
        }
        [headerView.backButton addTarget:self action:@selector(dismissSemi:) forControlEvents:UIControlEventTouchUpInside];
        reusableview = headerView;
        
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageGalleryCell *cell = (ImageGalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageGalleryCell" forIndexPath:indexPath];
    
    if (self.carDic) {
        NSMutableString* completeurl = [[NSMutableString alloc] init];
        [completeurl appendString:BaseImageUrl];
        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
        [completeurl appendString:[kImageFloder objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]]];
        [completeurl appendString:@"/"];
        
        [completeurl appendString:[[[self.carDic objectForKey:@"imageArray"] objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]] objectAtIndex:indexPath.row]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 深拷贝数据
    NSMutableArray *imgList = [NSMutableArray arrayWithCapacity:[[[self.carDic objectForKey:@"imageArray"] objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]]count]];
    for (int i = 0; i < [[[self.carDic objectForKey:@"imageArray"] objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]]count]; i++) {
    NSMutableString* completeurl = [[NSMutableString alloc] init];
    [completeurl appendString:BaseImageUrl];
    [completeurl appendString:[self.carDic objectForKey:@"carid"]];
    [completeurl appendString:[kImageFloder objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]]];
    [completeurl appendString:@"/"];
    [completeurl appendString:[[[self.carDic objectForKey:@"imageArray"] objectAtIndex:[[self.carDic objectForKey:@"sectionNumber"] integerValue]] objectAtIndex:i]];
    [imgList addObject:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    // 调用展示窗口
    ImgShowViewController *imgShow = [[ImgShowViewController alloc] initWithSourceData:imgList withIndex:indexPath.row];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imgShow];
    
    [self presentViewController:nav animated:YES completion:nil];
}
@end
