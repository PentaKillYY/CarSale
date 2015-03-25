//
//  MasterViewController.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-19.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
#define ImgArray [NSArray arrayWithObjects:@"http://img2.imgtn.bdimg.com/it/u=834958572,3645145128&fm=21&gp=0.jpg",@"http://pic12.nipic.com/20110222/6660820_111945190101_2.jpg",@"http://pica.nipic.com/2007-12-26/2007122602930235_2.jpg",@"http://pic9.nipic.com/20100902/5615113_084913055054_2.jpg",nil]


@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

