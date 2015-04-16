//
//  MenuRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "MenuRequest.h"

@implementation MenuRequest
+(instancetype)sharedMenuRequest{
    static MenuRequest *sharedMenuRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMenuRequest=[[MenuRequest alloc]init];
    });
    return sharedMenuRequest;
}

-(void)postMenuOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock
{
    [self postPath:kMenuTable withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
    
    }];
}
@end
