//
//  BaseHttpRequest.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDefine.h"
#import <AFHTTPRequestOperationManager.h>

typedef void(^JSONResponse)(id json);

@interface BaseHttpRequest : NSObject

-(void)postPath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock
      onFailure:(JSONResponse)failureBlock;
@end
