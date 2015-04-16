//
//  MenuRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@interface MenuRequest : BaseHttpRequest
+(instancetype)sharedMenuRequest;
-(void)postMenuOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
@end
