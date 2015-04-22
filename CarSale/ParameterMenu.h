//
//  ParameterMenu.h
//  CarSale
//
//  Created by HuangLuyang on 15-4-22.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface ParameterMenu : NSObject
@property(copy,nonatomic)NSString* menuId;
@property(copy,nonatomic)NSString* parentId;
@property(copy,nonatomic)NSString* menuText;
@end

@interface NSObject(PrintParameterMenuSQL)
+(NSString *)getCreateParameterMenuTableSQL;
@end