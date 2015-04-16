//
//  NSString+Array.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-31.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "NSString+Array.h"

@implementation NSString(Array)
+(NSArray*)seperateStringToArray:(NSString*)string{
    NSArray *seperateArray =[string componentsSeparatedByString:NSLocalizedString(@"|", nil)];
    return seperateArray;
}

@end
