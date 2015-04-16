//
//  Car.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-30.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"
#import "AppDefine.h"
@interface Car : NSObject
@property(copy,nonatomic)NSString* carId;
@property(copy,nonatomic)NSString* menuId;
//@property(copy,nonatomic)NSString* length;
//@property(copy,nonatomic)NSString* height;
//@property(copy,nonatomic)NSString* width;
@property(copy,nonatomic)NSString* color;
@property(copy,nonatomic)NSString* colorRGB;
@property(copy,nonatomic)NSString* carClass;
@property(copy,nonatomic)NSString* engine;
@property(copy,nonatomic)NSString* size;
@property(copy,nonatomic)NSString* topSpeed;
@property(copy,nonatomic)NSString* acceleration;
@property(copy,nonatomic)NSString* oilConsumption;
@property(copy,nonatomic)NSString* wheelBase;
@property(copy,nonatomic)NSString* intake;
@property(copy,nonatomic)NSString* cylinderType;
@property(copy,nonatomic)NSString* cylinderNumber;
@property(copy,nonatomic)NSString* reduction;
@property(copy,nonatomic)NSString* horsePower;
@property(copy,nonatomic)NSString* power;
@property(copy,nonatomic)NSString* torque;
@property(copy,nonatomic)NSString* fuelForm;
@property(copy,nonatomic)NSString* fuelGrade;
@property(copy,nonatomic)NSString* transMission;
@property(copy,nonatomic)NSString* gear;
@property(copy,nonatomic)NSString* transmissionType;
@property(copy,nonatomic)NSString* frontSuspension;
@property(copy,nonatomic)NSString* backSuspension;
@property(copy,nonatomic)NSString* airBag;
@property(copy,nonatomic)NSString* sideAirBag;
@property(copy,nonatomic)NSString* absType;
@property(copy,nonatomic)NSString* skyLight;
@property(copy,nonatomic)NSString* leatherSeat;
@property(copy,nonatomic)NSString* seatHeight;
@property(copy,nonatomic)NSString* foreImageUrl;
@property(copy,nonatomic)NSString* backImageUrl;
@property(copy,nonatomic)NSString* sideImageUrl;
@property(copy,nonatomic)NSString* innerImageUrl;
@property(copy,nonatomic)NSString* mainImageUrl;
@property(copy,nonatomic)NSString* carName;
@property(copy,nonatomic)NSString* numberId;
@end

@interface NSObject(PrintCarSQL)
+(NSString*)getCreateCarTableSQL;
@end
