//
//  VersionRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "BaseHttpRequest.h"

@interface VersionRequest : BaseHttpRequest
+(instancetype)sharedVersionRequest;
-(void)postVersionOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
@end
