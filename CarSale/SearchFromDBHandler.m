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
    if ([isMenu isEqualToString:@"Car"]) {
        [[DataBaseHelper sharedDatabaseHandler] selectCarIdFromCarWhere:parameter onSuccess:^(NSArray *array) {
            for (NSString* carId in array) {
                NSMutableDictionary* dic  = [[NSMutableDictionary alloc] init];
                [[DataBaseHelper sharedDatabaseHandler] selectCarInfoFromDataBaseWhere:carId onSuccess:^(NSArray *array) {
                    for (Car* car in array) {
                        [dic setObject:car.carName forKey:@"CarName"];
                        [[DataBaseHelper sharedDatabaseHandler] selectParameterMenuFromDataBaseOnSuccess:^(NSArray *array) {
                            NSMutableArray* parameterArray = [[NSMutableArray alloc] init];
                            for (NSDictionary* parameterDic in array) {
                                NSMutableDictionary* tempDic = [[NSMutableDictionary alloc] init];
                                
                                for (NSString* string in [parameterDic allKeys]) {
                                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                                    for (int i = 0; i <  [[[parameterDic allValues] objectAtIndex:0] count]; i++) {
                                        [[DataBaseHelper sharedDatabaseHandler] selectCarParameterFromDataBaseWhere:car.carId MenuText:[[[parameterDic allValues] objectAtIndex:0] objectAtIndex:i] onSuccess:^(NSArray *array) {
                                            [dic setObject:array[0] forKey:[[[parameterDic allValues] objectAtIndex:0] objectAtIndex:i]];
                                        }];
                                    }
                                    [tempDic setObject:dic forKey:string];
                                }
                                
                                [parameterArray addObject:tempDic];
                            }
                            [dic setObject:parameterArray forKey:@"Parameter"];
                        }];
                        [SuccessArray addObject:dic];
                    }
                    
                }];
                
            }
            success(SuccessArray);

        }];
        
    }else{
        [[DataBaseHelper sharedDatabaseHandler] selectCarIdFromDataBaseWhere:parameter onSuccess:^(NSArray *array) {
            for (NSString* carId in array) {
                NSMutableDictionary* dic  = [[NSMutableDictionary alloc] init];
                [[DataBaseHelper sharedDatabaseHandler] selectCarInfoFromDataBaseWhere:carId onSuccess:^(NSArray *array) {
                    for (Car* car in array) {
                        [dic setObject:car.carName forKey:@"CarName"];
                        [[DataBaseHelper sharedDatabaseHandler] selectParameterMenuFromDataBaseOnSuccess:^(NSArray *array) {
                            NSMutableArray* parameterArray = [[NSMutableArray alloc] init];
                            for (NSDictionary* parameterDic in array) {
                                NSMutableDictionary* tempDic = [[NSMutableDictionary alloc] init];
                                
                                for (NSString* string in [parameterDic allKeys]) {
                                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                                    for (int i = 0; i <  [[[parameterDic allValues] objectAtIndex:0] count]; i++) {
                                        [[DataBaseHelper sharedDatabaseHandler] selectCarParameterFromDataBaseWhere:car.carId MenuText:[[[parameterDic allValues] objectAtIndex:0] objectAtIndex:i] onSuccess:^(NSArray *array) {
                                            [dic setObject:array[0] forKey:[[[parameterDic allValues] objectAtIndex:0] objectAtIndex:i]];
                                        }];
                                    }
                                    [tempDic setObject:dic forKey:string];
                                }
                                
                                [parameterArray addObject:tempDic];
                            }
                            [dic setObject:parameterArray forKey:@"Parameter"];
                        }];
                        [SuccessArray addObject:dic];
                    }
                    
                }];
                
            }
            success(SuccessArray);
        }];
    }
}
@end
