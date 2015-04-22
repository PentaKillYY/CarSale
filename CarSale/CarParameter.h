//
//  CarParameter.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface CarParameter : NSObject
@property(copy,nonatomic)NSString* menuId;
@property(copy,nonatomic)NSString* carId;
@property(copy,nonatomic)NSString* menuText;
@end

@interface NSObject(PrintCarParameterSQL)
+(NSString *)getCreateCarParameterTableSQL;
@end