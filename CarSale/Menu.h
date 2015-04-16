//
//  Menu.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-26.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface Menu : NSObject
@property(copy,nonatomic)NSString* menuId;
@property(copy,nonatomic)NSString* parentId;
@property(copy,nonatomic)NSString* menuText;
@end

@interface NSObject(PrintMenuSQL)
+(NSString*)getCreateMenuTableSQL;
@end

