//
//  CarRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@interface CarRequest : BaseHttpRequest
+(instancetype)sharedCarRequest;
-(void)postCarOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;

@end
