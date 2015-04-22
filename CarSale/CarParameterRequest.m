//
//  CarParameterRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "CarParameterRequest.h"

@implementation CarParameterRequest
+(instancetype)sharedCarParameterRequest{
    static CarParameterRequest *sharedCarParameterRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCarParameterRequest=[[CarParameterRequest alloc]init];
    });
    return sharedCarParameterRequest;
}

-(void)postCarParameterOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
{
    [self postPath:kParameterTable withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        
    }];
}
@end
