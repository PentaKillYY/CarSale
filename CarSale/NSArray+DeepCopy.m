//
//  NSArray+DeepCopy.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-29.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "NSArray+DeepCopy.h"

@implementation NSArray(DeepCopy)
- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id value in self)
    {
        id oneCopy = nil;
        if ([value respondsToSelector:@selector(mutableDeepCopy)])
            oneCopy = [value mutableDeepCopy];
        else if ([value respondsToSelector:@selector(mutableCopy)])
            oneCopy = [value mutableCopy];
        if (oneCopy == nil)
            oneCopy = [value copy];
        [ret addObject: oneCopy];
    }
    return ret;
}
@end
