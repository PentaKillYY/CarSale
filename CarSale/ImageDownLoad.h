//
//  ImageDownLoad.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-31.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImageManager.h>

@interface ImageDownLoad : NSObject
+(instancetype)sharedImageDownLoad;
-(void)downLoadImageFromUrl:(NSString*)imgUrl;
@end
