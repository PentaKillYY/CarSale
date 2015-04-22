//
//  CarParameterRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@interface CarParameterRequest : BaseHttpRequest
+(instancetype)sharedCarParameterRequest;
-(void)postCarParameterOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
@end
