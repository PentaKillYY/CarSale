//
//  UILabel+CalculateSize.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-13.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "UILabel+CalculateSize.h"

@implementation UILabel(CalculateSize)
- (CGSize)calculateSize:(NSString*)contentText
{
    CGSize titleSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle.copy};
    titleSize = [contentText boundingRectWithSize:CGSizeMake(80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return titleSize;
}

@end
