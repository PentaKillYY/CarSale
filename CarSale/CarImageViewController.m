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
@interface CarImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger foreCount;
    NSInteger backCount;
    NSInteger innerCount;
    NSInteger sideCount;
    NSInteger cellCount;
}
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
            
            cellCount = 0;
            for (int i = 0; i < [[[self.carDic objectForKey:@"carimage"] allKeys] count]; i++) {
                if (i == 0) {
                    foreCount = [[[self.carDic objectForKey:@"carimage"] objectForKey:@"ForeImage"] count];
                    cellCount += foreCount;
                }else if (i == 1){
                    backCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"BackImage"] count];
                    cellCount += backCount;
                }else if (i == 2){
                    innerCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"InnerImage"] count];
                    cellCount += innerCount;
                }else{
                    sideCount= [[[self.carDic objectForKey:@"carimage"] objectForKey:@"SideImage"] count];
                    cellCount += sideCount;
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
    
    self.navigationItem.leftBarButtonItem = backItem;
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
        return cellCount;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageGalleryCell *cell = (ImageGalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageGalleryCell" forIndexPath:indexPath];
    
    if (self.carDic) {
        NSMutableString* completeurl = [[NSMutableString alloc] init];
        [completeurl appendString:BaseImageUrl];
        [completeurl appendString:[self.carDic objectForKey:@"carid"]];
        if (indexPath.row < foreCount) {
            [completeurl appendString:[kImageFloder objectAtIndex:0]];
            [completeurl appendString:@"/"];
            [completeurl appendString:[[[self.carDic objectForKey:@"carimage"] objectForKey:@"ForeImage"] objectAtIndex:indexPath.row]];
        }else if (foreCount <= indexPath.row &&  indexPath.row < (foreCount + backCount)){
            [completeurl appendString:[kImageFloder objectAtIndex:1]];
            [completeurl appendString:@"/"];
            [completeurl appendString:[[[self.carDic objectForKey:@"carimage"] objectForKey:@"BackImage"] objectAtIndex:(indexPath.row - foreCount)]];
        }else if ((foreCount + backCount) <= indexPath.row  && indexPath.row < (foreCount + backCount + sideCount)){
            [completeurl appendString:[kImageFloder objectAtIndex:3]];
            [completeurl appendString:@"/"];
            [completeurl appendString:[[[self.carDic objectForKey:@"carimage"] objectForKey:@"InnerImage"] objectAtIndex:indexPath.row - (foreCount + backCount)]];
        }else{
            [completeurl appendString:[kImageFloder objectAtIndex:2]];
            [completeurl appendString:@"/"];
            [completeurl appendString:[[[self.carDic objectForKey:@"carimage"] objectForKey:@"SideImage"] objectAtIndex:indexPath.row - (foreCount + backCount + sideCount)]];
        }
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    return cell;
}

#pragma mark -NavAction
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
