//
//  VersionRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "VersionRequest.h"

@implementation VersionRequest
+(instancetype)sharedVersionRequest{
    static VersionRequest *sharedVersionRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVersionRequest=[[VersionRequest alloc]init];
    });
    return sharedVersionRequest;
}

-(void)postVersionOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock
{
    [self postPath:kVersion withParameters:nil onCompletion:^(id json) {
        completionBlock(json);
        
    } onFailure:^(id json) {
        
    }];
}
@end
