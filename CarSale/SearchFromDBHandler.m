//
//  SearchFromDBHandler.m
//  CarSale
//
//  Created by HuangLuyang on 15-4-1.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "SearchFromDBHandler.h"

@implementation SearchFromDBHandler
+(instancetype)sharedSearchHandler{
    static SearchFromDBHandler *sharedSearchHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSearchHandler=[[SearchFromDBHandler alloc]init];
    });
    return sharedSearchHandler;
}

-(void)getMenuFromDataBase:(SearchSuccess)success{
    [[DataBaseHelper sharedDatabaseHandler] selectMenuFromDatabaseOnSuccess:^(NSArray *array) {
        success(array);
    }];
}

-(void)getCarNameFromDataBaseWhere:(NSString*)menuText OnSuccess:(SearchSuccess)success;{
    [[DataBaseHelper sharedDatabaseHandler] selectCarNameFromDataBaseWhere:menuText OnSuccess:^(NSArray *array) {
        success(array);
    }];
}

-(void)getCarInfoDataBaseWhere:(NSString*)menuText OnSuccess:(SearchSuccess)success{

    [[DataBaseHelper sharedDatabaseHandler] selectCarFromDataBaseWhere:menuText OnSuccess:^(NSArray *array) {
        success(array);
    }];
}

//-(void)getDefaultCarInfoFromDatabaseOnSuccess:(SearchSuccess)success{
//
//    [[DataBaseHelper sharedDatabaseHandler] selectDefaultCarFromDataBaseOnSuccess:^(NSArray *array) {
//        success(array);
//    }];
//}
@end
