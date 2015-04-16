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
#import "RecipeCollectionHeaderView.h"
#import "CollectionViewCell.h"
#import "AppDefine.h"
#import "NSString+Array.h"
#import <UIImageView+WebCache.h>
#import "ImgShowViewController.h"
#import "UIView+Shadow.h"
#import <DWBubbleMenuButton.h>
#import "UIColor+HexColor.h"
#import "DXSemiViewControllerCategory.h"
#import <MBProgressHUD.h>

@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XCMultiTableViewDataSource,ShowAllImageDelegate>
{
    XCMultiTableView * xcMultiTableView;
    NSString* carId;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}
@property(strong,nonatomic)IBOutlet UIView* carColorView;
@property(strong,nonatomic)IBOutlet UIImageView* carColorBG;
@property(strong,nonatomic)IBOutlet UIView* carInfoView;
@property(strong,nonatomic)IBOutlet UICollectionView* imageCollectionView;
@property(strong,nonatomic)IBOutlet UIImageView* infoView;
@property(retain,nonatomic)NSMutableArray* carInfoArray;
@property(retain,nonatomic)NSMutableArray* imageArray;
@property(retain,nonatomic)IBOutlet UIImageView* mainCarImg;
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
    
    if (self.detailItem) {
        carId = [[NSString alloc] init];
        self.imageArray = [[NSMutableArray alloc] init];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.yOffset = 27;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [[SearchFromDBHandler sharedSearchHandler] getCarInfoDataBaseWhere:[self.detailItem description] OnSuccess:^(NSArray *array) {
                self.carInfoArray = [NSMutableArray arrayWithArray:array];
                [self prepareCarId];
                [self prepareCarInfoDataSource];
                [self prepareCarImageDataSource:0];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [self setCarInfoGridView];
                [self setMainCarImageView:0];
                [self setColorSelectedView];
                [self setCarImageSectionView];
            });
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
    self.infoView.highlighted = YES;
    self.mainCarImg.contentMode = UIViewContentModeScaleAspectFill;
    [self setViewBackgroundShadow];
    if ([[_detailItem description] isEqualToString:@"0"]|| !_detailItem) {
        [self setDetailItem:@"0"];
    }
}


-(void)setColorSelectedView
{
    UILabel *homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(10.f,
                                                                                              25.f,
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
    }
    for (NSString *hexColor in colorRGBArray) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.f, 0.f, 25.f, 25.f);
        button.backgroundColor = [UIColor colorWithHexString:hexColor];
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
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    [self setMainCarImageView:sender.tag];
    [self prepareCarImageDataSource:sender.tag];

}

-(void)setViewBackgroundShadow
{
    [self.carColorView makeInsetShadowWithRadius:10.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] Directions:[NSArray arrayWithObjects:@"left", nil]];
    [self.carInfoView makeInsetShadowWithRadius:10.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] Directions:[NSArray arrayWithObjects:@"left", nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCarId
{
    for (Car* car in self.carInfoArray) {
        carId = car.carId;
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
    headData = [NSMutableArray arrayWithCapacity:self.carInfoArray.count];
    for (NSString* info in kCarInfoCategory) {
        [headData addObject:info];
    }
    
    leftTableData = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:3];
    [one addObject:@"数值"];
    [leftTableData addObject:one];
    rightTableData = [NSMutableArray arrayWithCapacity:kCarInfoCategory.count];
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:kCarInfoCategory.count];
    for (int i = 0; i < 1; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:kCarInfoCategory.count];
        for (int j = 0; j < kCarInfoCategory.count; j++) {
            for (Car* car in self.carInfoArray) {
                [ary addObject:car.carClass];
                [ary addObject:car.size];
                [ary addObject:car.topSpeed];
                [ary addObject:car.acceleration];
                [ary addObject:car.oilConsumption];
                [ary addObject:car.wheelBase];
                [ary addObject:car.intake];
                [ary addObject:car.cylinderType];
                [ary addObject:car.cylinderNumber];
                [ary addObject:car.reduction];
                [ary addObject:car.horsePower];
                [ary addObject:car.engine];
                [ary addObject:car.power];
                [ary addObject:car.torque];
                [ary addObject:car.fuelForm];
                [ary addObject:car.fuelGrade];
                [ary addObject:car.transMission];
                [ary addObject:car.gear];
                [ary addObject:car.transmissionType];
                [ary addObject:car.frontSuspension];
                [ary addObject:car.backSuspension];
                [ary addObject:car.airBag];
                [ary addObject:car.sideAirBag];
                [ary addObject:car.absType];
                [ary addObject:car.skyLight];
                [ary addObject:car.leatherSeat];
                [ary addObject:car.seatHeight];
            }
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
}

-(void)setCarInfoGridView{
    if (xcMultiTableView) {
        [xcMultiTableView removeFromSuperview];
    }
    xcMultiTableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(CGRectMake(10, 75, 694, 120), 5.0f, 5.0f)];
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

#pragma mark -  CollectionViewDataPrepre

- (void)prepareCarImageDataSource:(NSInteger)colorIndex
{
    NSArray* colorArray;
    for (Car* car in self.carInfoArray) {
        colorArray = [NSArray arrayWithArray:[NSString seperateStringToArray:car.color]] ;
        NSMutableArray* tempforeImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempbackImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempsideImage = [[NSMutableArray alloc] init];
        NSMutableArray* tempinnerImage = [[NSMutableArray alloc] init];
        for (NSString* foreurl in [NSString seperateStringToArray:car.foreImageUrl]) {
            if ([foreurl rangeOfString:[colorArray objectAtIndex:colorIndex]].location != NSNotFound) {
                [tempforeImage addObject:foreurl];
            }
        }
        for (NSString* backurl in [NSString seperateStringToArray:car.backImageUrl]) {
            if ([backurl rangeOfString:[colorArray objectAtIndex:colorIndex]].location != NSNotFound) {
                [tempbackImage addObject:backurl];
            }
        }
        for (NSString* sideurl in [NSString seperateStringToArray:car.sideImageUrl]) {
            if ([sideurl rangeOfString:[colorArray objectAtIndex:colorIndex]].location != NSNotFound) {
                [tempsideImage addObject:sideurl];
            }
        }
        for (NSString* innerurl in [NSString seperateStringToArray:car.innerImageUrl]) {
            if ([innerurl rangeOfString:[colorArray objectAtIndex:colorIndex]].location != NSNotFound) {
                [tempinnerImage addObject:innerurl];
            }
        }
        
        [self.imageArray addObject:tempforeImage];
        [self.imageArray addObject:tempbackImage];
        [self.imageArray addObject:tempsideImage];
        [self.imageArray addObject:tempinnerImage];
    }
}

-(void)setCarImageSectionView
{
    [self.imageCollectionView reloadData];
}

#pragma mark -  CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (!self.imageArray.count) {
        return 0;
    }
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.imageArray.count) {
        return 0;
    }else if ([[self.imageArray objectAtIndex:section] count] > 12){
        return 12;
    }else{
        return [[self.imageArray objectAtIndex:section]count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (self.imageArray.count) {
        NSMutableString* completeurl = [[NSMutableString alloc] init];
        [completeurl appendString:BaseImageUrl];
        [completeurl appendString:carId];
        [completeurl appendString:kImageFloder[indexPath.section]];
        [completeurl appendString:@"/"];
    
        [completeurl appendString:[[self.imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell.carImageView sd_setImageWithURL:[NSURL URLWithString:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView.delegate = self;
        if (!self.imageArray.count) {
            headerView.galleryNameLabel.text = @"";
            headerView.galleryNumberlabel.text = @"0 张";
        }else{
            headerView.galleryNameLabel.text = kImageCategory[indexPath.section];
            headerView.galleryNumberlabel.text = [NSString stringWithFormat:@"%ld 张",(unsigned long)[[self.imageArray objectAtIndex:indexPath.section] count]];
            headerView.showAllButton.tag = indexPath.section;
        }
        
        reusableview = headerView;
    
    }
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 深拷贝数据
    NSMutableArray *imgList = [NSMutableArray arrayWithCapacity:[[self.imageArray objectAtIndex:indexPath.section]count]];
    for (int i = 0; i < [[self.imageArray objectAtIndex:indexPath.section]count]; i++) {
        NSMutableString* completeurl = [[NSMutableString alloc] init];
        [completeurl appendString:BaseImageUrl];
        [completeurl appendString:carId];
        [completeurl appendString:kImageFloder[indexPath.section]];
        [completeurl appendString:@"/"];
        [completeurl appendString:[self.imageArray objectAtIndex:indexPath.section][i]];
        [imgList addObject:[completeurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    // 调用展示窗口
    ImgShowViewController *imgShow = [[ImgShowViewController alloc] initWithSourceData:imgList withIndex:indexPath.row];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imgShow];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)shouldShowAllImageView:(id)sender
{
    UIButton* button = (UIButton*)sender;
    DXSemiViewController* semiViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DXSemi"];
    NSDictionary* cardic = @{@"sectionNumber":[NSString stringWithFormat:@"%d",button.tag],@"carid":carId,@"imageArray":self.imageArray,@"titlename":[NSString stringWithFormat:@"%@    %ld 张",kImageCategory[button.tag],(unsigned long)[[self.imageArray objectAtIndex:button.tag] count]]};
    [self setRightSemiViewController:semiViewController Title:cardic];
}
@end
