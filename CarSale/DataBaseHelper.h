//
//  DataBaseHelper.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-30.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
#import "Car.h"
#import "CarParameter.h"
#import "ParameterMenu.h"
#import "LKDBHelper.h"
#import "AppDefine.h"

typedef void(^Success)(NSArray* array);
typedef void(^SuccessDic)(NSDictionary* dictionary);
@interface DataBaseHelper : NSObject
+(instancetype)sharedDatabaseHandler;
-(void)initializeDataBase;
-(void)createTable;
-(void)dropTable;
-(void)cleanTabledata;
-(void)saveMenuData:(NSArray*)dataArray;
-(void)saveCarData:(NSArray*)dataArray;
-(void)saveCarParameterData:(NSArray*)dataArray;
-(void)saveParameterMenuData:(NSArray*)dataArray;
-(void)selectAllImageFromDatabaseOnSuccess:(Success)success;
-(void)selectMenuFromDatabaseOnSuccess:(Success)success;
-(void)selectCarNameFromDataBaseWhere:(NSString*)menuText OnSuccess:(Success)success;
-(void)selectCarFromDataBaseWhere:(NSString*)menuText OnSuccess:(Success)success;
-(void)selectMenuIdFromdataBaseWhere:(NSString*)menuText onSuccess:(Success)success;
-(void)selectParameterFromDataBaseWhere:(NSString*)carId menuID:(NSString*)menuid OnSuccess:(Success)success;
-(void)selectCarIdFromDataBaseWhere:(NSString*)menuText onSuccess:(Success)success;
-(void)selectBasicCarInfoFromDataBase:(NSString*)carId onSuccess:(SuccessDic)success;
-(void)selectParameterNameFromDataBase:(NSString*)menuId onSuccess:(Success)success;
@end
