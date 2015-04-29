//
//  DetailViewController.m
//  CarSale
//
//  Created by HuangLuyang on 15-3-19.
//  Copyright (c) 2015年 Huang Luyang. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchFromDBHandler.h"
#import "XCMultiSortTableView.h"
#import "CollectionViewCell.h"
#import "AppDefine.h"
#import "NSString+Array.h"
#import <UIImageView+WebCache.h>
#import "ImgShowViewController.h"
#import "UIView+Shadow.h"
#import <DWBubbleMenuButton.h>
#import "UIColor+HexColor.h"
#import "DXSemiViewControllerCategory.h"
#import "MoreCarInfoViewController.h"
#import "CarImageViewController.h"
#import <MBProgressHUD.h>

@interface DetailViewController ()<XCMultiTableViewDataSource>
{
    XCMultiTableView * xcMultiTableView;
    NSString* carId;
    NSString* carName;
    NSArray* carColorArray;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    CAGradientLayer *_gradientLayer;
}
@property(strong,nonatomic)IBOutlet UIView* carBrandView;
@property(strong,nonatomic)IBOutlet UILabel* carNameLabel;
@property(strong,nonatomic)IBOutlet UILabel* carPriceLabel;
@property(strong,nonatomic)IBOutlet UILabel* manufactureLabel;
@property(strong,nonatomic)IBOutlet UILabel* carClassLabel;
@property(strong,nonatomic)IBOutlet UIView* carColorView;
@property(strong,nonatomic)IBOutlet UIImageView* carColorBG;
@property(strong,nonatomic)IBOutlet UIView* carInfoView;
@property(strong,nonatomic)IBOutlet UICollectionView* imageCollectionView;
@property(strong,nonatomic)IBOutlet UIImageView* infoView;
@property(retain,nonatomic)NSMutableArray* carInfoArray;
@property(retain,nonatomic)NSMutableArray* carParameterArray;
@property(retain,nonatomic)NSMutableDictionary* imageDic;
@property(retain,nonatomic)NSMutableDictionary* infoDic;
@property(retain,nonatomic)IBOutlet UIImageView* mainCarImg;
@property(strong,nonatomic)IBOutlet UIButton* imageButton;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    NSDictionary* detailDic = (NSDictionary*)_detailItem;
    NSString* detailKey = [detailDic allKeys][0];
    NSString* detailValue = [detailDic allValues][0];
    self.imageDic = [[NSMutableDictionary alloc] init];
    self.infoDic = [[NSMutableDictionary alloc] init];
    if (self.detailItem && [detailKey isEqualToString:@"Car"]) {
        self.imageButton.hidden = NO;
        carId = [[NSString alloc] init];
        carName = [[NSString alloc] init];

            [[SearchFromDBHandler sharedSearchHandler] getCarInfoDataBaseWhere:detailValue OnSuccess:^(NSArray *array) {
                self.carInfoArray = [NSMutableArray arrayWithArray:array];
                [self prepareCarId];
                [self prepareCarImageDataSource];
                [[SearchFromDBHandler sharedSearchHandler] getCarBrandInfoFromDataBaseWhere:carId OnSuccess:^(NSDictionary *dic) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [self setMainCarImageView:0];
                        [self setColorSelectedView];
                        [self setCarBrandViewInfo:dic];
                    });
                }];
                
                [[SearchFromDBHandler sharedSearchHandler] getCarParameterFromDataBaseWhere:@"Car" Parameter:detailValue onSuccess:^(NSArray *array) {
                    self.carParameterArray = [NSMutableArray arrayWithArray:array];
                    [self prepareCarInfoDataSource];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setCarInfoGridView];
                    });
                }];

            }];

    }else if (self.detailItem && [detailKey isEqualToString:@"Menu"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageButton.hidden = YES;
            [self.carColorView setHidden:YES];
            
            [self setCarBrandViewInfo:detailDic];
        });
        
        [[SearchFromDBHandler sharedSearchHandler] getCarParameterFromDataBaseWhere:@"Menu" Parameter:detailValue onSuccess:^(NSArray *array) {
            self.carParameterArray = [NSMutableArray arrayWithArray:array];
            [self prepareCarInfoDataSource];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCarInfoGridView];
            });

        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
    self.infoView.highlighted = YES;
    self.mainCarImg.contentMode = UIViewContentModeScaleAspectFill;
    [self setViewBackgroundShadow];
    NSDictionary* detailDic = (NSDictionary*)_detailItem;
    NSString* detailKey = [detailDic allKeys][0];
    NSString* detailValue = [detailDic allValues][0];
    if (([detailKey isEqualToString:@"Car"] && [detailValue isEqualToString:@"0"]) || !_detailItem) {
        [self setDetailItem:@{@"Car":@"0"}];
    }
}

-(void)setCarBrandViewInfo:(NSDictionary*)dataDic
{
    NSDictionary* detailDic = (NSDictionary*)_detailItem;
    NSString* detailKey = [detailDic allKeys][0];
    NSString* detailValue = [detailDic allValues][0];
    
    if ([detailKey isEqualToString:@"Car"]) {
        self.carPriceLabel.text =[NSString stringWithFormat:@"%@:%@",kCarBrand[0],[dataDic objectForKey:kCarBrand[0]]];
        self.carClassLabel.text = [NSString stringWithFormat:@"%@:%@",kCarBrand[2],[dataDic objectForKey:kCarBrand[2]]];
        self.manufactureLabel.text = [NSString stringWithFormat:@"%@:%@",kCarBrand[1],[dataDic objectForKey:kCarBrand[1]]];
        self.carNameLabel.text = carName;
    }else{
        self.carNameLabel.text = detailValue;
    }
    
}

-(void)setColorSelectedView
{
    UILabel *homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(10.f,
                                                                                              105.f,
                                                                                              homeLabel.frame.size.width,
                                                                                              homeLabel.frame.size.height)
                                                                expansionDirection:DirectionRight];
    downMenuButton.homeButtonView = homeLabel;
        [downMenuButton addButtons:[self createDemoButtonArray]];
    
    
    [self.view addSubview:downMenuButton];

}

- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.0f, 40.0f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    NSArray* colorRGBArray;
    for (Car* car in self.carInfoArray) {
        
        colorRGBArray = [NSArray arrayWithArray:[NSString seperateStringToArray:car.colorRGB]] ;
        carColorArray = [NSArray arrayWithArray:[NSString seperateStringToArray:car.color]];
    }
    for (NSString *hexColor in colorRGBArray) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.f, 0.f, 25.f, 25.f);
        button.backgroundColor = [UIColor colorWithHexString:hexColor];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = button.bounds;
        _gradientLayer.borderWidth = 0;
        _gradientLayer.frame = button.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[[UIColor colorWithHexString:hexColor] CGColor],(id)[[UIColor clearColor] CGColor],nil ];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        
        [button.layer insertSublayer:_gradientLayer atIndex:0];
        [button.layer setBorderWidth:2.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1 , 1, 1 });
        [button.layer setBorderColor:colorref];

        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.clipsToBounds = YES;
        button.showsTouchWhenHighlighted = YES;
        button.tag = i++;
        [button addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    return [buttonsMutable copy];
}

- (void)changeColor:(UIButton *)sender {
    [self setMainCarImageView:sender.tag];
}

-(void)setViewBackgroundShadow
{
    [self.carColorView makeInsetShadowWithRadius:10.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] Directions:[NSArray arrayWithObjects:@"left", nil]];
    [self.carInfoView makeInsetShadowWithRadius:10.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] Directions:[NSArray arrayWithObjects:@"left", nil]];
    [self.carBrandView makeInsetShadowWithRadius:10.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] Directions:[NSArray arrayWithObjects:@"left", nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCarId
{
    for (Car* car in self.carInfoArray) {
        carId = car.carId;
        carName = car.carName;
    }
}

-(void)setMainCarImageView:(NSInteger)colorIndex{
    for (Car* car in self.carInfoArray) {
        NSMutableString* completeurl = [[NSMutableString alloc] init];
        [completeurl appendString:BaseImageUrl];
        [completeurl appendString:carId];
        [completeurl appendString:kImageFloder[4]];
        [completeurl appendString:@"/"];
        [completeurl appendString:[[NSString seperateStringToArray:car.mainImageUrl] objectAtIndex:colorIndex]];
        [self.mainCarImg sd_setImageWithURL:[NSURL URLWithString:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

#pragma mark - CarInfoDataPrepare

-(void)prepareCarInfoDataSource{
    NSInteger headCount = self.carParameterArray.count;
    NSInteger leftCount = [[[[[[self.carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:0] allValues]objectAtIndex:0] allKeys].count;
    NSInteger rightCount = [[[[[[self.carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:0] allValues]objectAtIndex:0] allValues].count;
    //------添加车名源--------------------------------------
    headData = [NSMutableArray arrayWithCapacity:headCount];
    
    for (NSDictionary* car in self.carParameterArray) {
        [headData addObject:[car objectForKey:@"CarName"]];
    }
    //------添加参数名源
    leftTableData = [NSMutableArray arrayWithCapacity:leftCount];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:leftCount];
    for (NSString* string in [[[[[[self.carParameterArray objectAtIndex:0] objectForKey:@"Parameter"] objectAtIndex:0] allValues]objectAtIndex:0] allKeys]) {
        [one addObject:string];
    }
    [leftTableData addObject:one];
    
    //------添加参数值源
    rightTableData = [NSMutableArray arrayWithCapacity:rightCount];
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:rightCount];
    for (int i = 0; i < leftCount; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:rightCount];
            for (int k = 0; k < headCount; k++) {
                 [ary addObject:[[[[[[[self.carParameterArray objectAtIndex:k] objectForKey:@"Parameter"] objectAtIndex:0] allValues]objectAtIndex:0] allValues] objectAtIndex:i]];
            }
        
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
    [self.infoDic setObject:self.carParameterArray forKey:@"CarInfo"];
}

-(void)setCarInfoGridView{
    if (xcMultiTableView) {
        [xcMultiTableView removeFromSuperview];
    }
    CGFloat width;
    CGFloat height;
    if (100 * headData.count > 694) {
        width = 694.0f;
    }else{
        width =100.0f * headData.count;
    }
    NSDictionary* detailDic = (NSDictionary*)_detailItem;
    NSString* detailKey = [detailDic allKeys][0];
    if ([detailKey isEqualToString:@"Car"]) {
        if (60*leftTableData.count > 277) {
            height = 277.0f;
        }else{
            height = 277.0f;
        }
        self.carInfoView.frame = CGRectMake(self.carInfoView.frame.origin.x, self.carInfoView.frame.origin.y, self.carInfoView.frame.size.width, self.carInfoView.frame.size.height);
    }else{
        if (60*leftTableData.count > 527) {
            height = 527.0f;
        }else{
            height = 527.0f;
        }
        self.carInfoView.frame = CGRectMake(self.carInfoView.frame.origin.x, self.carInfoView.frame.origin.y-250, self.carInfoView.frame.size.width, self.carInfoView.frame.size.height+250);
    }
    
    
    xcMultiTableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(CGRectMake(10, 75, width+100, height+60), 5.0f, 5.0f)];
    xcMultiTableView.leftHeaderEnable = YES;
    xcMultiTableView.datasource = self;
    
    [self.carInfoView addSubview:xcMultiTableView];
    [xcMultiTableView reloadData];
    
}


#pragma mark - XCMultiTableViewDataSource

- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    return 100.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {        return 60.0f;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    return [UIColor grayColor];
}

//#pragma mark -  CollectionViewDataPrepre
//
- (void)prepareCarImageDataSource
{
    for (Car* car in self.carInfoArray) {
        NSMutableArray* tempforeImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempbackImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempsideImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempinnerImage = [[NSMutableArray alloc] init];
        for (NSString* foreurl in [NSString seperateStringToArray:car.foreImageUrl]) {
            [tempforeImage addObject:foreurl];
        }
        for (NSString* backurl in [NSString seperateStringToArray:car.backImageUrl]) {
            [tempbackImage addObject:backurl];
        }
        for (NSString* sideurl in [NSString seperateStringToArray:car.sideImageUrl]) {
            [tempsideImage addObject:sideurl];
        }
        for (NSString* innerurl in [NSString seperateStringToArray:car.innerImageUrl]) {
            [tempinnerImage addObject:innerurl];
        }
        [self.imageDic setObject:tempforeImage forKey:@"ForeImage"];
        [self.imageDic setObject:tempbackImage forKey:@"BackImage"];
        [self.imageDic setObject:tempsideImage forKey:@"SideImage"];
        [self.imageDic setObject:tempinnerImage forKey:@"InnerImage"];
    }
}

-(IBAction)showMoreCarInfo:(id)sender{
    MoreCarInfoViewController* moreCarInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreCarInfo"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:moreCarInfo];
    NSDictionary* cardic = @{@"carname":self.carNameLabel.text,@"carinfo":self.infoDic};
    [moreCarInfo setDetailItem:cardic];
    [self presentViewController:nav animated:YES completion:nil];
}

-(IBAction)showAllImage:(id)sender{
    CarImageViewController* carImage = [self.storyboard  instantiateViewControllerWithIdentifier:@"CarImage"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:carImage];
    NSDictionary* cardic = @{@"carid":carId,@"carname":carName,@"carimage":self.imageDic,@"carcolor":carColorArray};
    [carImage setDetailItem:cardic];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
