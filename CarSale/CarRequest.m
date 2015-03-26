//
//  CarRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "CarRequest.h"

@implementation CarRequest
+(instancetype)sharedHttpRequest{
    static CarRequest *sharedHttpRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHttpRequest=[[CarRequest alloc]init];
    });
    return sharedHttpRequest;
}

-(void)postCarOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock
{
    [self postPath:kCarTable withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        
    }];
}
@end
