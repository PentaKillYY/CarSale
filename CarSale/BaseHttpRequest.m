//
//  BaseHttpRequest.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@implementation BaseHttpRequest

-(void)postPath:(NSString *)path withParameters:(NSDictionary *)parameters onCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock 
{
    NSString* httpUrl = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:httpUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
