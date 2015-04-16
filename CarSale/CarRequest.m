//
//  CarRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "CarRequest.h"

@implementation CarRequest
+(instancetype)sharedCarRequest{
    static CarRequest *sharedCarRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCarRequest=[[CarRequest alloc]init];
    });
    return sharedCarRequest;
}

-(void)postCarOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock
{
    [self postPath:kCarTable withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        
    }];
}
@end
