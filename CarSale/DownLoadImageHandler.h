//
//  DownLoadImageHandler.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-31.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownLoad.h"
#import "DataBaseHelper.h"
#import "Car.h"
#import "NSString+Array.h"

typedef void(^ImgSuccess)(NSInteger count);

@interface DownLoadImageHandler : NSObject
{
    NSInteger imageCount ;
}
+(instancetype)sharedImageHandler;
-(void)downLoadImageToDiskOnSuccess:(ImgSuccess)success;
@end
