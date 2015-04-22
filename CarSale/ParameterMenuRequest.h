//
//  ParameterMenuRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@interface ParameterMenuRequest : BaseHttpRequest
+(instancetype)sharedParameterMenuRequest;
-(void)postParameterMenuOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
@end
