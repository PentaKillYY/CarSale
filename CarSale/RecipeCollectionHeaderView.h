//
//  RecipeCollectionHeaderView.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-8.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowAllImageDelegate <NSObject>

-(void)shouldShowAllImageView:(id)sender;

@end

@interface RecipeCollectionHeaderView : UICollectionReusableView
@property(strong,nonatomic) IBOutlet UILabel* galleryNameLabel;
@property(strong,nonatomic) IBOutlet UILabel* galleryNumberlabel;
@property(strong,nonatomic) IBOutlet UIButton* showAllButton;
@property(assign,nonatomic) id <ShowAllImageDelegate>delegate;
-(IBAction)showAllImageList:(id)sender;
@end


