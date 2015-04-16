//
//  MainSectionview.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-1.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "MainSectionview.h"

@implementation MainSectionview
- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"MainSectionView" owner:self options:nil];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderSelected)];
    [self.contentView addGestureRecognizer:tap];
    [self addSubview:self.contentView];
}

-(void)changeHeaderSelected{
    [self.SelectedDelegate shouldChangeRow:self.contentView.tag];
}
@end
