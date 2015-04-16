//
//  LaunchViewController.h
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController
{
    NSInteger allInteger;
    NSInteger completedInteger;
}
@property (weak,nonatomic)IBOutlet UIProgressView* progressView;
@end
