//
//  ParameterMenuRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "ParameterMenuRequest.h"

@implementation ParameterMenuRequest
+(instancetype)sharedParameterMenuRequest{
    static ParameterMenuRequest *sharedParameterMenuRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParameterMenuRequest=[[ParameterMenuRequest alloc]init];
    });
    return sharedParameterMenuRequest;
}

-(void)postParameterMenuOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
{
    [self postPath:kParameterMenuTable withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        
    }];
}
@end
