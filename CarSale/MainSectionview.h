//
//  MainSectionview.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-1.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContentSlected <NSObject>
-(void)shouldChangeRow:(NSInteger)sectionNumber;
@end

@interface MainSectionview : UIView

@property(weak,nonatomic)IBOutlet UIView *contentView;
@property(weak,nonatomic)IBOutlet UIImageView* imageView;
@property(weak,nonatomic)IBOutlet UILabel* label;
@property(assign,nonatomic)id <ContentSlected>SelectedDelegate;

@end


