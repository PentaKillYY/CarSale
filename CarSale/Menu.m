//
//  Menu.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "Menu.h"

@implementation Menu
+(NSString *)getTableName
{
    return @"MenuTable";
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
    [self setTableColumnName:@"MenuId" bindingPropertyName:@"menuId"];
    [self setTableColumnName:@"PerentId" bindingPropertyName:@"parentId"];
    [self setTableColumnName:@"MenuText" bindingPropertyName:@"menuText"];
}

+(NSString *)getPrimaryKey
{
    return @"MenuId";
}

@end

@implementation NSObject(PrintMenuSQL)

+(NSString *)getCreateMenuTableSQL
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
