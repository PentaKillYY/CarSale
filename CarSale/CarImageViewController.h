//
//  CarImageViewController.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarImageViewController : UIViewController
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary* carDic;
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@end
