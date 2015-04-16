//
//  DownLoadImageHandler.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-31.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "DownLoadImageHandler.h"

@implementation DownLoadImageHandler
+(instancetype)sharedImageHandler{
    static DownLoadImageHandler *downLoadImageHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoadImageHandler=[[DownLoadImageHandler alloc]init];
    });
    return downLoadImageHandler;
}

-(void)downLoadImageToDiskOnSuccess:(ImgSuccess)success{
    [[DataBaseHelper sharedDatabaseHandler] selectAllImageFromDatabaseOnSuccess:^(NSArray *array) {
        
        for (Car* car in array) {
            NSArray* imgAry = @[[NSString seperateStringToArray:car.foreImageUrl],[NSString seperateStringToArray:car.backImageUrl],[NSString seperateStringToArray:car.sideImageUrl],[NSString seperateStringToArray:car.innerImageUrl],[NSString seperateStringToArray:car.mainImageUrl]];
            
            for (int i = 0; i < imgAry.count; i++) {
                for (NSString* name in imgAry[i]) {
                    NSMutableString* imageCompleteUrl =[[NSMutableString alloc] init];
                    [imageCompleteUrl appendString:BaseImageUrl];
                    [imageCompleteUrl appendString:car.carId];
                    [imageCompleteUrl appendString:kImageFloder[i]];
                    [imageCompleteUrl appendString:[NSString stringWithFormat:@"/%@",name]];
                    imageCount += 1;
                    [[ImageDownLoad sharedImageDownLoad] downLoadImageFromUrl:imageCompleteUrl];
                }
            }
        }
        success(imageCount);
    }];
}
@end
