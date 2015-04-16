//
//  RecipeCollectionHeaderView.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-8.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "RecipeCollectionHeaderView.h"

@implementation RecipeCollectionHeaderView
-(IBAction)showAllImageList:(id)sender{
    [self.delegate shouldShowAllImageView:sender];
}
@end
