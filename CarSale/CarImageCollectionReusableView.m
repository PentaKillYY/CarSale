//
//  CarImageCollectionReusableView.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-28.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "CarImageCollectionReusableView.h"

@implementation CarImageCollectionReusableView
-(IBAction)showColorContent:(id)sender{
    [self.delegate shouldShowColorView:sender];
}

-(IBAction)showImageTypeContent:(id)sender{
    [self.delegate shouldShowTypeView:sender];
}
@end
