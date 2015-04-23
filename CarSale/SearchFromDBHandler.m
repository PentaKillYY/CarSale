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

-(void)getCarBrandInfoFromDataBaseWhere:(NSString*)carId OnSuccess:(DicSearchSuccess)success
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for (NSString* string in kCarBrand) {
        [[DataBaseHelper sharedDatabaseHandler] selectMenuIdFromdataBaseWhere:string onSuccess:^(NSArray *array) {
            if (array) {
                [[DataBaseHelper sharedDatabaseHandler] selectParameterFromDataBaseWhere:carId menuID:array[0] OnSuccess:^(NSArray *array) {
                    [dic setObject:array[0] forKey:string];
                }];
            }
         }];
    }
    success(dic);
}

-(void)getCarParameterFromDataBaseWhere:(NSString*)isMenu Parameter:(NSString*)parameter onSuccess:(SearchSuccess)success{
    NSMutableArray* SuccessArray = [[NSMutableArray alloc] init];
    if ([isMenu isEqualToString:@"Menu"]) {
        [[DataBaseHelper sharedDatabaseHandler] selectCarIdFromDataBaseWhere:parameter onSuccess:^(NSArray *array) {
            for (NSString* string in array) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                [[DataBaseHelper sharedDatabaseHandler] selectBasicCarInfoFromDataBase:string onSuccess:^(NSDictionary *dictionary) {
                    for (NSString* string in [dictionary allKeys]) {
                        [[DataBaseHelper sharedDatabaseHandler] selectParameterNameFromDataBase:string onSuccess:^(NSArray *array) {
                            [dic setObject:[dictionary objectForKey:string] forKey:array[0]];
                        }];
                    }
                }];
                [SuccessArray addObject:dic];
            }
            success(SuccessArray);
        }];
    }else{
        [[DataBaseHelper sharedDatabaseHandler] selectCarFromDataBaseWhere:parameter OnSuccess:^(NSArray *array) {
            for (Car* car in array) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
               [[DataBaseHelper sharedDatabaseHandler] selectBasicCarInfoFromDataBase:car.carId onSuccess:^(NSDictionary *dictionary) {
                   for (NSString* string in [dictionary allKeys]) {
                       [[DataBaseHelper sharedDatabaseHandler] selectParameterNameFromDataBase:string onSuccess:^(NSArray *array) {
                           [dic setObject:[dictionary objectForKey:string] forKey:array[0]];
                       }];
                   }
               }];
             [SuccessArray addObject:dic];
            }
            success(SuccessArray);
        }];
        
    }
}
@end
