//
//  LaunchViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-27.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "LaunchViewController.h"
#import "VersionRequest.h"
#import "UpdateHandler.h"
#import "DownLoadImageHandler.h"
#import <MBProgressHUD.h>
@interface LaunchViewController ()<UISplitViewControllerDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageProgress) name:@"imagefinished" object:nil];
    [super viewWillAppear:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imagefinished" object:nil];
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
