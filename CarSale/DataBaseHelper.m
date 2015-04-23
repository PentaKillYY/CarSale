//
//  DataBaseHelper.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-30.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "DataBaseHelper.h"
@interface DataBaseHelper(){
    LKDBHelper* menuHelper;
    LKDBHelper* carHelper;
    LKDBHelper* carParameterHelper;
    LKDBHelper* parameterMenuHelper;
}
@end

@implementation DataBaseHelper
+(instancetype)sharedDatabaseHandler{
    static DataBaseHelper *sharedDatabaseHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatabaseHandler=[[DataBaseHelper alloc]init];
    });
    return sharedDatabaseHandler;
}

-(void)initializeDataBase{
    menuHelper = [Menu getUsingLKDBHelper];
    carHelper = [Car getUsingLKDBHelper];
    carParameterHelper = [CarParameter getUsingLKDBHelper];
    parameterMenuHelper = [ParameterMenu getUsingLKDBHelper];
}

-(void)createTable{
    [Menu getCreateMenuTableSQL];
    [Car getCreateCarTableSQL];
    [CarParameter getCreateCarParameterTableSQL];
    [ParameterMenu getCreateParameterMenuTableSQL];
}

-(void)dropTable{
    [menuHelper dropAllTable];
    [carHelper dropAllTable];
    [carParameterHelper dropAllTable];
    [parameterMenuHelper dropAllTable];
}

-(void)cleanTabledata{
    [LKDBHelper clearTableData:[Menu class]];
    [LKDBHelper clearTableData:[Car class]];
    [LKDBHelper clearTableData:[CarParameter class]];
    [LKDBHelper clearTableData:[ParameterMenu class]];
}

-(void)saveMenuData:(NSArray*)dataArray{
    for (int i = 0; i < dataArray.count; i++) {
        Menu* menu = [[Menu alloc] init];
        menu.parentId = [[dataArray objectAtIndex:i] objectForKey:kParentId];
        menu.menuId = [[dataArray objectAtIndex:i] objectForKey:kMenuId];
        menu.menuText = [[dataArray objectAtIndex:i] objectForKey:kMenuText];
        [menu saveToDB];
    }
}

-(void)saveCarData:(NSArray*)dataArray{
    for (int j = 0; j < dataArray.count; j++) {
        Car* car = [[Car alloc] init];
        car.carId = [[dataArray objectAtIndex:j] objectForKey:kCarId];
        car.carName = [[dataArray objectAtIndex:j] objectForKey:kCarName];
        car.menuId = [[dataArray objectAtIndex:j] objectForKey:kMenuId];
        car.color = [[dataArray objectAtIndex:j] objectForKey:kClor];
        car.colorRGB  = [[dataArray objectAtIndex:j] objectForKey:kColorRGB];
        car.carClass = [[dataArray objectAtIndex:j] objectForKey:kCarClass];
        car.engine = [[dataArray objectAtIndex:j] objectForKey:kEngine];
        car.size = [[dataArray objectAtIndex:j] objectForKey:kSize];
        car.topSpeed = [[dataArray objectAtIndex:j] objectForKey:kTopSpeed];
        car.acceleration = [[dataArray objectAtIndex:j] objectForKey:kAcceleration];
        car.oilConsumption = [[dataArray objectAtIndex:j] objectForKey:kOilConsumption];
        car.wheelBase = [[dataArray objectAtIndex:j] objectForKey:kWheelBase];
        car.intake = [[dataArray objectAtIndex:j] objectForKey:kIntake];
        car.cylinderType = [[dataArray objectAtIndex:j] objectForKey:kCylinderType];
        car.cylinderNumber = [[dataArray objectAtIndex:j] objectForKey:kCylinderNumber];
        car.reduction = [[dataArray objectAtIndex:j] objectForKey:kReduction];
        car.horsePower = [[dataArray objectAtIndex:j] objectForKey:kHorsePower];
        car.torque = [[dataArray objectAtIndex:j] objectForKey:kTorque];
        car.fuelForm = [[dataArray objectAtIndex:j] objectForKey:kFuelForm];
        car.fuelGrade = [[dataArray objectAtIndex:j] objectForKey:kFuelGrade];
        car.transMission = [[dataArray objectAtIndex:j] objectForKey:kTransMission];
        car.gear = [[dataArray objectAtIndex:j] objectForKey:kGear];
        car.transmissionType = [[dataArray objectAtIndex:j] objectForKey:kTransmissionType];
        car.frontSuspension = [[dataArray objectAtIndex:j] objectForKey:kFrontSuspension];
        car.backSuspension = [[dataArray objectAtIndex:j] objectForKey:kBackSuspension];
        car.airBag = [[dataArray objectAtIndex:j] objectForKey:kAirBag];
        car.sideAirBag = [[dataArray objectAtIndex:j] objectForKey:kSideAirBag];
        car.absType = [[dataArray objectAtIndex:j] objectForKey:kAbsType];
        car.skyLight = [[dataArray objectAtIndex:j] objectForKey:kSkyLight];
        car.leatherSeat = [[dataArray objectAtIndex:j] objectForKey:kLeatherSeat];
        car.seatHeight = [[dataArray objectAtIndex:j] objectForKey:kSeatHeight];
        car.power = [[dataArray objectAtIndex:j] objectForKey:kCarPower];
        car.foreImageUrl = [[dataArray objectAtIndex:j] objectForKey:kForeImage];
        car.backImageUrl = [[dataArray objectAtIndex:j] objectForKey:kBackImage];
        car.sideImageUrl = [[dataArray objectAtIndex:j] objectForKey:kSideImage];
        car.innerImageUrl = [[dataArray objectAtIndex:j] objectForKey:kInnerImage];
        car.mainImageUrl = [[dataArray objectAtIndex:j] objectForKey:kMainImage];
        car.numberId = [NSString stringWithFormat:@"%d",j];
        [car saveToDB];
    }
}


-(void)saveCarParameterData:(NSArray*)dataArray
{
    for (int  k= 0; k < dataArray.count; k++) {
        CarParameter* carParameter = [[CarParameter alloc] init];
        carParameter.menuId = [[dataArray objectAtIndex:k] objectForKey:kMenuId];
        carParameter.parameterText = [[dataArray objectAtIndex:k] objectForKey:kParameterText];
        carParameter.carId = [[dataArray objectAtIndex:k] objectForKey:kCarId];
        carParameter.numberId = [NSString stringWithFormat:@"%d",k];
        [carParameter saveToDB];
    }
}

-(void)saveParameterMenuData:(NSArray*)dataArray
{
    for (int  i= 0; i < dataArray.count; i++) {
        ParameterMenu* parameterMenu = [[ParameterMenu alloc] init];
        parameterMenu.menuId = [[dataArray objectAtIndex:i] objectForKey:kMenuId];
        parameterMenu.menuText = [[dataArray objectAtIndex:i] objectForKey:kMenuText];
        parameterMenu.parentId = [[dataArray objectAtIndex:i] objectForKey:kParentId];
        [parameterMenu saveToDB];
    }
}

-(void)selectAllImageFromDatabaseOnSuccess:(Success)success{
    [self initializeDataBase];
    [carHelper search:[Car class] where:nil orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        success(array);
    }];

}

-(void)selectMenuFromDatabaseOnSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* RootParentArray = [menuHelper search:[Menu class] column:@"MenuId" where:@"MenuText = '根节点'" orderBy:nil offset:0 count:1000];
    NSMutableString* rootParentId = [RootParentArray objectAtIndex:0];
    NSArray* MenuId = [menuHelper search:[Menu class] where:@{@"PerentId":rootParentId} orderBy:nil offset:0 count:1000];
    NSMutableArray* responseArray = [[NSMutableArray alloc] init];
    for (Menu* menu in MenuId) {
       NSArray* array =  [menuHelper search:[Menu class] column:@"MenuText" where:@{@"PerentId":menu.menuId} orderBy:nil offset:0 count:1000];
        NSArray* menuArray = @[menu.menuText,array];
        [responseArray addObject:menuArray];
    }
    success(responseArray);
}

-(void)selectCarNameFromDataBaseWhere:(NSString*)menuText OnSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* menuIdArray = [menuHelper search:[Menu class] column:@"MenuId" where:@{@"MenuText":menuText} orderBy:nil offset:0 count:1000];
    NSMutableArray* carArray = [[NSMutableArray alloc] init];
   [self selectAllImageFromDatabaseOnSuccess:^(NSArray *array) {
       for (Car* car in array) {
           if ([car.menuId rangeOfString:menuIdArray[0]].location != NSNotFound) {
               [carArray addObject:car.carName];
           }
       }
       success((NSArray*)carArray);
   }];
    
}

-(void)selectCarFromDataBaseWhere:(NSString*)menuText OnSuccess:(Success)success{
    [self initializeDataBase];
    if ([menuText isEqualToString:@"0"]) {
        [carHelper search:[Car class] where:@{@"NumberId":@"0"} orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
            success((NSArray*)array);
        }];
    }else{
        [carHelper search:[Car class] where:@{@"CarName":menuText} orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
            success((NSArray*)array);
        }];
    }
    
}

-(void)selectMenuIdFromdataBaseWhere:(NSString*)menuText onSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* menuIdArray = [parameterMenuHelper search:[ParameterMenu class] column:@"MenuId" where:@{@"MenuText":menuText} orderBy:nil offset:0 count:10000];
    success(menuIdArray);
}

-(void)selectParameterFromDataBaseWhere:(NSString*)carId menuID:(NSString*)menuid OnSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* parameterArray = [carParameterHelper search:[CarParameter class] column:@"ParameterText" where:@{@"CarId":carId,@"MenuId":menuid} orderBy:nil offset:0 count:10000];
    success(parameterArray);
}

-(void)selectCarIdFromDataBaseWhere:(NSString*)menuText onSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* menuIdArray = [menuHelper search:[Menu class] column:@"MenuId" where:@{@"MenuText":menuText} orderBy:nil offset:0 count:1000];
    NSMutableArray* carArray = [[NSMutableArray alloc] init];
    [self selectAllImageFromDatabaseOnSuccess:^(NSArray *array) {
        for (Car* car in array) {
            if ([car.menuId rangeOfString:menuIdArray[0]].location != NSNotFound) {
                [carArray addObject:car.carId];
            }
        }
        success((NSArray*)carArray);
    }];
}

-(void)selectBasicCarInfoFromDataBase:(NSString*)carId onSuccess:(SuccessDic)success{
    [self initializeDataBase];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    NSArray* array = [carParameterHelper search:[CarParameter class] where:@{@"CarId":carId} orderBy:nil offset:0 count:10000];

    for (CarParameter* parameter in array) {
        [dic setObject:parameter.parameterText forKey:parameter.menuId];
    }
    success(dic);
}


-(void)selectParameterNameFromDataBase:(NSString*)menuId onSuccess:(Success)success{
    [self initializeDataBase];
    NSArray* array = [parameterMenuHelper search:[ParameterMenu class] column:@"MenuText" where:@{@"MenuId":menuId} orderBy:nil offset:0 count:10000];
    success(array);
}
@end
