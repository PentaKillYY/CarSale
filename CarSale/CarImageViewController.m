//
//  CarImageViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "CarImageViewController.h"
#import <MBProgressHUD.h>
#import "ImageGalleryCell.h"
#import <UIImageView+WebCache.h>
#import "AppDefine.h"
#import "CarImageCollectionReusableView.h"
#import "PopContentViewController.h"
@interface CarImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DidSelectDelegate>
{
    NSInteger foreCount;
    NSInteger backCount;
    NSInteger innerCount;
    NSInteger sideCount;
    NSInteger cellCount;
    NSMutableArray* dataSourceArray;
}
@property (nonatomic, strong) UIPopoverController *colorPopController;
@property (nonatomic, strong) UIPopoverController* typePopController;
@end

@implementation CarImageViewController
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            sleep(1);
            self.carDic = [NSDictionary dictionaryWithDictionary:(NSDictionary*)_detailItem];
            dataSourceArray = [[NSMutableArray alloc] init];
            cellCount = 0;
            
            
            for (int i = 0; i < [[[self.carDic objectForKey:@"carimage"] allKeys] count]; i++) {
                if (i == 0) {
                    foreCount = [[[self.carDic objectForKey:@"carimage"] objectForKey:@"ForeImage"] count];
                    cellCount += foreCount;
                    for (NSString* string in [[self.carDic objectForKey:@"carimage"] objectForKey:@"ForeImage"]) {
                        NSMutableString* completeurl = [[NSMutableString alloc] init];
                        [completeurl appendString:BaseImageUrl];
                        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
                        [completeurl appendString:[kImageFloder objectAtIndex:i]];
                        [completeurl appendString:@"/"];
                        [completeurl appendString:string];
                        [dataSourceArray addObject:completeurl];
                    }
                }else if (i == 1){
                    backCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"BackImage"] count];
                    cellCount += backCount;
                    for (NSString* string in [[self.carDic objectForKey:@"carimage"] objectForKey:@"BackImage"]) {
                        NSMutableString* completeurl = [[NSMutableString alloc] init];
                        [completeurl appendString:BaseImageUrl];
                        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
                        [completeurl appendString:[kImageFloder objectAtIndex:i]];
                        [completeurl appendString:@"/"];
                        [completeurl appendString:string];
                        [dataSourceArray addObject:completeurl];
                    }
                }else if (i == 2){
                    sideCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"SideImage"] count];
                    cellCount += sideCount;
                    for (NSString* string in [[self.carDic objectForKey:@"carimage"] objectForKey:@"SideImage"]) {
                        NSMutableString* completeurl = [[NSMutableString alloc] init];
                        [completeurl appendString:BaseImageUrl];
                        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
                        [completeurl appendString:[kImageFloder objectAtIndex:i]];
                        [completeurl appendString:@"/"];
                        [completeurl appendString:string];
                        [dataSourceArray addObject:completeurl];
                    }
                    
                }else{
                    
                    innerCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"InnerImage"] count];
                    cellCount += innerCount;
                    for (NSString* string in [[self.carDic objectForKey:@"carimage"] objectForKey:@"InnerImage"]) {
                        NSMutableString* completeurl = [[NSMutableString alloc] init];
                        [completeurl appendString:BaseImageUrl];
                        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
                        [completeurl appendString:[kImageFloder objectAtIndex:i]];
                        [completeurl appendString:@"/"];
                        [completeurl appendString:string];
                        [dataSourceArray addObject:completeurl];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                self.title = [self.carDic objectForKey:@"carname"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.collectionView reloadData];
            });
        });
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加导航栏退回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIBarButtonItem* colorItem = [[UIBarButtonItem alloc] initWithTitle:@"全部颜色" style:UIBarButtonItemStylePlain target:self action:@selector(showContentView:)];
    colorItem.tag = 0;
    UIBarButtonItem* typeItem = [[UIBarButtonItem alloc] initWithTitle:@"全部类型" style:UIBarButtonItemStylePlain target:self action:@selector(showContentView:)];
    typeItem.tag = 1;
    NSArray* rightItem = @[colorItem,typeItem];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItems = rightItem;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
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
        return dataSourceArray.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageGalleryCell *cell = (ImageGalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageGalleryCell" forIndexPath:indexPath];
    
    if (self.carDic) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1 , 1, 1 });
        [cell.imageView.layer setBorderColor:colorref];
        [cell.imageView.layer setBorderWidth:2.0];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[dataSourceArray objectAtIndex:indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    return cell;
}

#pragma mark -NavAction
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showContentView:(id)sender{
    UIBarButtonItem* item = (UIBarButtonItem*)sender;
    if (item.tag == 0) {
        if (self.colorPopController.popoverVisible) {
            [self.colorPopController dismissPopoverAnimated:YES];
            return;
        }else{
            if (self.typePopController.popoverVisible) {
                [self.typePopController dismissPopoverAnimated:YES];
            }
            PopContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopContent"];
            contentViewController.delegate = self;
            [contentViewController setDetailItem:[self.carDic objectForKey:@"carcolor"]];
            UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
            popController.popoverContentSize = contentViewController.view.frame.size;
            self.colorPopController = popController;
            [self.colorPopController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        
    }else{
        if (self.typePopController.popoverVisible) {
            [self.typePopController dismissPopoverAnimated:YES];
            return;
        }else{
            if (self.colorPopController.popoverVisible) {
                [self.colorPopController dismissPopoverAnimated:YES];
            }
            PopContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopContent"];
            contentViewController.delegate = self;
            [contentViewController setDetailItem:kImageCategory];
            UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
            popController.popoverContentSize = contentViewController.view.frame.size;
            self.typePopController = popController;
            [self.typePopController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

-(void)cellDidSelect:(NSString*)cellText{
    [self.colorPopController dismissPopoverAnimated:YES];
    [self.colorPopController dismissPopoverAnimated:YES];
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",cellText];
}
@end
