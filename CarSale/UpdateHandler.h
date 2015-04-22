//
//  UpdateHandler.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuRequest.h"
#import "CarRequest.h"
#import "CarParameterRequest.h"
#import "ParameterMenuRequest.h"
#import "VersionRequest.h"
#import "DataBaseHelper.h"
typedef void(^UpdateSuccess)(NSInteger isSuccess);
typedef void(^VersionState)(BOOL isLatest) ;
@interface UpdateHandler : NSObject
+(instancetype)sharedUpdateHandler;
-(void)checkDatabaseVersionOnState:(VersionState)state;
-(void)updateDateBaseDataOnSuccess:(UpdateSuccess)success;
@end
