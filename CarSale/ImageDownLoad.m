//
//  ImageDownLoad.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-31.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "ImageDownLoad.h"

@implementation ImageDownLoad
+(instancetype)sharedImageDownLoad{
    static ImageDownLoad *sharedImageDownLoad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageDownLoad=[[ImageDownLoad alloc]init];
    });
    return sharedImageDownLoad;
}

-(void)downLoadImageFromUrl:(NSString*)imgUrl{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       if (image && finished) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"imagefinished" object:nil];
       }
   }];
}
@end
