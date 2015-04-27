//
//  SearchFromDBHandler.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-1.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseHelper.h"
#import "AppDefine.h"
typedef void(^SearchSuccess)(NSArray* array);
typedef void(^DicSearchSuccess)(NSDictionary* dic);

@interface SearchFromDBHandler : NSObject
+(instancetype)sharedSearchHandler;
-(void)getMenuFromDataBase:(SearchSuccess)success;
-(void)getCarNameFromDataBaseWhere:(NSString*)menuText OnSuccess:(SearchSuccess)success;
-(void)getCarInfoDataBaseWhere:(NSString*)menuText OnSuccess:(SearchSuccess)success;
//-(void)getDefaultCarInfoFromDatabaseOnSuccess:(SearchSuccess)success;
-(void)getCarBrandInfoFromDataBaseWhere:(NSString*)carId OnSuccess:(DicSearchSuccess)success;
-(void)getCarParameterFromDataBaseWhere:(NSString*)isMenu Parameter:(NSString*)parameter onSuccess:(SearchSuccess)success;

@end
