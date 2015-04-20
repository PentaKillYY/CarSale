//
//  LaunchViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDefine.h"
#import "VersionRequest.h"
#import "UpdateHandler.h"
#import "DownLoadImageHandler.h"
#import <MBProgressHUD.h>
#import <AFNetworkReachabilityManager.h>

@interface LaunchViewController ()<UISplitViewControllerDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"无网络");
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请检查网络连接";
            [hud hide:YES afterDelay:2];
        }else{
            NSLog(@"有网络");
            [self updateData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageProgress) name:@"imagefinished" object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [super viewWillAppear:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imagefinished" object:nil];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [super viewWillDisappear:YES];
}



-(void)updateData
{
    [[UpdateHandler sharedUpdateHandler] updateDateBaseDataOnSuccess:^(NSInteger isSuccess) {
        [[DownLoadImageHandler sharedImageHandler] downLoadImageToDiskOnSuccess:^(NSInteger count) {
            allInteger = count;
            [[VersionRequest sharedVersionRequest] postVersionOnCompletion:^(id json) {
                NSArray* versionArray = (NSArray*)json;
                NSString* remoteVersion = [versionArray objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setValue:remoteVersion forKey:@"VersionCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } onFailure:^(id json) {
                
            }];
            
        }];
    }];
}


-(void)changeImageProgress{
    completedInteger += 1;
    float progress = (float)completedInteger/(float)allInteger;
    [self.progressView setProgress:progress];
    if (progress == 1.0) {
        sleep(1);
        UIStoryboard  * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UISplitViewController* splitViewController = (UISplitViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"splitViewController"];
        splitViewController.delegate = self;
        self.view.window.rootViewController = splitViewController;
    }
}
@end
