//
//  UpdateHandler.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "UpdateHandler.h"

@implementation UpdateHandler
+(instancetype)sharedUpdateHandler{
    static UpdateHandler *sharedUpdateHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUpdateHandler=[[UpdateHandler alloc]init];
    });
    return sharedUpdateHandler;
}

-(void)checkDatabaseVersionOnState:(VersionState)state{
    [[VersionRequest sharedVersionRequest] postVersionOnCompletion:^(id json) {
        if (json) {
            NSArray* versionArray = (NSArray*)json;
            NSString* remoteVersion = [versionArray objectAtIndex:0];
            
            NSString* localVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"VersionCount"];
                if ([remoteVersion integerValue] > [localVersion integerValue]) {

                    state(NO);
                }else{
                    state(YES);
                }
        }
    } onFailure:^(id json) {
            
    }];
}

-(void)updateDateBaseDataOnSuccess:(UpdateSuccess)success
{
    [[DataBaseHelper sharedDatabaseHandler] cleanTabledata];
    [[DataBaseHelper sharedDatabaseHandler] createTable];
    
    [[MenuRequest sharedMenuRequest] postMenuOnCompletion:^(id json) {
        if (json) {
            NSArray* menuArray = (NSArray*)json;
            [[DataBaseHelper sharedDatabaseHandler] saveMenuData:menuArray];
            
            [[CarRequest sharedCarRequest] postCarOnCompletion:^(id json) {
                if (json) {
                    NSArray* carArray = (NSArray*)json;
                    [[DataBaseHelper sharedDatabaseHandler] saveCarData:carArray];
                    [[CarParameterRequest sharedCarParameterRequest] postCarParameterOnCompletion:^(id json) {
                        if (json) {
                            NSArray* carParameterArray = (NSArray*)json;
                            [[DataBaseHelper sharedDatabaseHandler] saveCarParameterData:carParameterArray];
                            [[ParameterMenuRequest sharedParameterMenuRequest] postParameterMenuOnCompletion:^(id json) {
                                if (json) {
                                    NSArray* parameterMenuArray = (NSArray*)json;
                                    [[DataBaseHelper sharedDatabaseHandler] saveParameterMenuData:parameterMenuArray];
                                    success(1);
                                }
                                
                            } onFailure:^(id json) {
                                
                            }];
                        }
                    } onFailure:^(id json) {
                        
                    }];
                }
            } onFailure:^(id json) {
                
            }];
            
        }
    } onFailure:^(id json) {
        
    }];
}
@end
