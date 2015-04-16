//
//  Car.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-30.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "Car.h"

@implementation Car
+(NSString *)getTableName
{
    return @"CarTable";
}

//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]init];
    });
    return db;
}

//在类 初始化的时候
+(void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"error"];
    
    //enable the column binding property name
    [self setTableColumnName:@"CarId" bindingPropertyName:@"carId"];
    [self setTableColumnName:@"MenuId" bindingPropertyName:@"menuId"];
//    [self setTableColumnName:@"Length" bindingPropertyName:@"lenght"];
//    [self setTableColumnName:@"Width" bindingPropertyName:@"width"];
//    [self setTableColumnName:@"Height" bindingPropertyName:@"height"];
    [self setTableColumnName:@"Color" bindingPropertyName:@"color"];
    [self setTableColumnName:@"ColorRGB" bindingPropertyName:@"colorRGB"];
    [self setTableColumnName:@"CarClass" bindingPropertyName:@"carClass"];
    
    [self setTableColumnName:@"Engine" bindingPropertyName:@"engine"];
    [self setTableColumnName:@"Size" bindingPropertyName:@"size"];
    [self setTableColumnName:@"TopSpeed" bindingPropertyName:@"topSpeed"];
    [self setTableColumnName:@"Acceleration" bindingPropertyName:@"acceleration"];
    [self setTableColumnName:@"OilConsumption" bindingPropertyName:@"oilConsumption"];
    [self setTableColumnName:@"WheelBase" bindingPropertyName:@"wheelBase"];
    [self setTableColumnName:@"Intake" bindingPropertyName:@"intake"];
    [self setTableColumnName:@"CylinderType" bindingPropertyName:@"CylinderType"];
    [self setTableColumnName:@"CylinderNumber" bindingPropertyName:@"cylinderNumber"];
    [self setTableColumnName:@"Reduction" bindingPropertyName:@"reduction"];
    [self setTableColumnName:@"HorsePower" bindingPropertyName:@"horsePower"];
    [self setTableColumnName:@"Torque" bindingPropertyName:@"torque"];
    [self setTableColumnName:@"FuelForm" bindingPropertyName:@"fuelForm"];
    [self setTableColumnName:@"FuelGrade" bindingPropertyName:@"fuelGrade"];
    [self setTableColumnName:@"TransMission" bindingPropertyName:@"transMission"];
    [self setTableColumnName:@"Gear" bindingPropertyName:@"gear"];
    [self setTableColumnName:@"TransmissionType" bindingPropertyName:@"transmissionType"];
    [self setTableColumnName:@"FrontSuspension" bindingPropertyName:@"frontSuspension"];
    [self setTableColumnName:@"BackSuspension" bindingPropertyName:@"backSuspension"];
    [self setTableColumnName:@"AirBag" bindingPropertyName:@"airBag"];
    [self setTableColumnName:@"SideAirBag" bindingPropertyName:@"sideAirBag"];
    [self setTableColumnName:@"AbsType" bindingPropertyName:@"absType"];
    [self setTableColumnName:@"SkyLight" bindingPropertyName:@"skyLight"];
    [self setTableColumnName:@"LeatherSeat" bindingPropertyName:@"leatherSeat"];
    [self setTableColumnName:@"SeatHeight" bindingPropertyName:@"seatHeight"];
    [self setTableColumnName:@"Power" bindingPropertyName:@"power"];
    [self setTableColumnName:@"ForeImageUrl" bindingPropertyName:@"foreImageUrl"];
    [self setTableColumnName:@"BackImageUrl" bindingPropertyName:@"backImageUrl"];
    [self setTableColumnName:@"SideImageUrl" bindingPropertyName:@"sideImageUrl"];
    [self setTableColumnName:@"InnerImageUrl" bindingPropertyName:@"innerImageUrl"];
    [self setTableColumnName:@"MainImageUrl" bindingPropertyName:@"mainImageUrl"];
    [self setTableColumnName:@"CarName" bindingPropertyName:@"carName"];
    [self setTableColumnName:@"NumberId" bindingPropertyName:@"numberId"];
}

+(NSString *)getPrimaryKey

{
    return @"CarId";
}
@end

@implementation NSObject(PrintCarSQL)

+(NSString *)getCreateCarTableSQL
{
    LKModelInfos* infos = [self getModelInfos];
    NSString* primaryKey = [self getPrimaryKey];
    NSMutableString* table_pars = [NSMutableString string];
    for (int i=0; i<infos.count; i++) {
        
        if(i > 0)
            [table_pars appendString:@","];
        
        LKDBProperty* property =  [infos objectWithIndex:i];
        [self columnAttributeWithProperty:property];
        
        [table_pars appendFormat:@"%@ %@",property.sqlColumnName,property.sqlColumnType];
        
        if([property.sqlColumnType isEqualToString:LKSQL_Type_Text])
        {
            if(property.length>0)
            {
                [table_pars appendFormat:@"(%ld)",(long)property.length];
            }
        }
        if(property.isNotNull)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_NotNull];
        }
        if(property.isUnique)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_Unique];
        }
        if(property.checkValue)
        {
            [table_pars appendFormat:@" %@(%@)",LKSQL_Attribute_Check,property.checkValue];
        }
        if(property.defaultValue)
        {
            [table_pars appendFormat:@" %@ %@",LKSQL_Attribute_Default,property.defaultValue];
        }
        if(primaryKey && [property.sqlColumnName isEqualToString:primaryKey])
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_PrimaryKey];
        }
    }
    NSString* createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",[self getTableName],table_pars];
    return createTableSQL;
}
@end