//
//  CarImageCollectionReusableView.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-28.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowContentDelegate <NSObject>

-(void)shouldShowColorView:(id)sender;
-(void)shouldShowTypeView:(id)sender;

@end
@interface CarImageCollectionReusableView : UICollectionReusableView
@property(strong,nonatomic) IBOutlet UIButton* colorButton;
@property(strong,nonatomic) IBOutlet UIButton* imageTypeButton;
@property(assign,nonatomic) id <ShowContentDelegate>delegate;
-(IBAction)showColorContent:(id)sender;
-(IBAction)showImageTypeContent:(id)sender;
@end
