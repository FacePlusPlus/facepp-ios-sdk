//
//  ViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/16.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "ViewController.h"
#import "FCDetectViewController.h"
#import "FCCompareViewController.h"
#import "FCSearchViewController.h"
#import "FCBaseViewController.h"
#import "FCBodyDetectViewController.h"
#import "FCBodySegmentViewController.h"
#import "FCOCRIDCardViewController.h"
#import "FCOCRDriverLicenceViewController.h"
#import "FCOCRVehicleLicenseViewController.h"
#import "FCmergefaceViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong , nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = @[@[@{@"title" : @"人脸检测",@"selector" : @"detectFace"},
                         @{@"title" : @"人脸比对(1:1)",@"selector" : @"compareFace"},
                         @{@"title" : @"人脸搜索(1:N)",@"selector" : @"searchFace"}],
                       
                       @[@{@"title" : @"人体识别",@"selector" : @"detectBody"},
                         @{@"title" : @"人体抠图",@"selector" : @"bodySegment"}],
                       
                       @[@{@"title" : @"身份证识别",@"selector" : @"ocrIdCard"},
                         @{@"title" : @"驾驶证识别",@"selector" : @"ocrDriverLicense"},
                         @{@"title" : @"行驶证识别",@"selector" : @"ocrVehicleLicense"}],
                       
                       @[@{@"title":@"人脸融合",@"selector":@"mergeface"}]];
}

- (void)detectFace{
    FCDetectViewController *detectVC = [[FCDetectViewController alloc] init];
    detectVC.image = [UIImage imageNamed:@"demo-pic.jpg"];
    [self.navigationController pushViewController:detectVC animated:YES];
}

- (void)compareFace{
    FCCompareViewController *comapareVC = [[FCCompareViewController alloc] init];
    [self.navigationController pushViewController:comapareVC animated:YES];
}

- (void)searchFace{
    FCSearchViewController *comapareVC = [[FCSearchViewController alloc] init];
    [self.navigationController pushViewController:comapareVC animated:YES];
}

- (void)detectBody{
    FCBodyDetectViewController *bodyVC = [[FCBodyDetectViewController alloc] init];
    bodyVC.image = [UIImage imageNamed:@"body.jpg"];
    [self.navigationController pushViewController:bodyVC animated:YES];
}

- (void)bodySegment{
    FCBodySegmentViewController *bodyVC = [[FCBodySegmentViewController alloc] init];
    bodyVC.image = [UIImage imageNamed:@"body.jpg"];
    [self.navigationController pushViewController:bodyVC animated:YES];
}

- (void)ocrIdCard{
    FCOCRIDCardViewController *idCardVC = [[FCOCRIDCardViewController alloc] init];
    idCardVC.image = [UIImage imageNamed:@"idcard.jpg"];
    [self.navigationController pushViewController:idCardVC animated:YES];
}

- (void)ocrDriverLicense{
    FCOCRDriverLicenceViewController *driverLicenceVC = [[FCOCRDriverLicenceViewController alloc] init];
    driverLicenceVC.image = [UIImage imageNamed:@"jiashizheng.jpg"];
    [self.navigationController pushViewController:driverLicenceVC animated:YES];
}

- (void)ocrVehicleLicense{
    FCOCRVehicleLicenseViewController *vehicleLicenseVC = [[FCOCRVehicleLicenseViewController alloc] init];
    vehicleLicenseVC.image = [UIImage imageNamed:@"xingshizheng.jpg"];
    [self.navigationController pushViewController:vehicleLicenseVC animated:YES];
}

-(void)mergeface{
    FCmergefaceViewController* mergefaceVC = [[FCmergefaceViewController alloc]init];
    [self.navigationController pushViewController:mergefaceVC animated:YES];

    
}

#pragma mark- delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectorStr = self.dataArray[indexPath.section][indexPath.row][@"selector"];
    SEL selector = NSSelectorFromString(selectorStr);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"tableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row][@"title"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tableFooterView == nil) {
        tableView.tableFooterView = [[UIView alloc] init];
    }
    return [self.dataArray[section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:93/255.0 green:177/255.0 blue:229/255.0 alpha:1.0];
    NSString *title = nil;
    switch (section) {
        case 0:
        {
            title = @"  人脸识别";
        }
            break;
        case 1:
        {
            title = @"  人体识别";
        }
            break;
        case 2:
        {
            title = @"  OCR识别";
        }
            break;
        case 3:
        {
            title = @"  图像识别";
        }
            break;
        default:
            break;
    }

    label.text = title;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
