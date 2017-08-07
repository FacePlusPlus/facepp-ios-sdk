//
//  FCOCRVehicleLicenseViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/19.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCOCRVehicleLicenseViewController.h"
#import "NSMutableAttributedString+FCExtension.h"

@interface FCOCRVehicleLicenseViewController ()

@end

@implementation FCOCRVehicleLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPOCR *ocr = [[FCPPOCR alloc] initWithImage:image];
    self.imageView.image = ocr.image;
    NSLog(@"%f",ocr.image.imageData.length/1024.0/1024.0);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ocr ocrVehicleLicenseCompletion:^(id info, NSError *error) {
        [hud hideAnimated:YES];
        self.tableView.contentOffset = CGPointMake(0, 0);
        [self.dataArray removeAllObjects];
        if (info) {
            [self showResult:info];
            NSArray *array = info[@"cards"];
            [self.dataArray addObjectsFromArray:array];
        }else{
            [self showError:error];
        }
        [self.tableView reloadData];
    }];
}
#pragma mark- tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"vehicleCellllId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fccellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] init];
    BOOL isFront = [dic[@"side"] isEqualToString:@"front"];
    
    if (isFront) {
        [detailStr appendBoldString:@"号牌号码: "];
        [detailStr appendLightString:dic[@"plate_no"]];
        [detailStr appendBoldString:@"\n车辆类型: "];
        [detailStr appendLightString:dic[@"vehicle_type"]];
        [detailStr appendBoldString:@"\n所有人: "];
        [detailStr appendLightString:dic[@"owner"]];
        [detailStr appendBoldString:@"\n住址: "];
        [detailStr appendLightString:dic[@"address"]];
        [detailStr appendBoldString:@"\n使用性质: "];
        [detailStr appendLightString:dic[@"use_character"]];
        [detailStr appendBoldString:@"\n品牌型号: "];
        [detailStr appendLightString:dic[@"model"]];
        [detailStr appendBoldString:@"\n车辆识别代码: "];
        [detailStr appendLightString:dic[@"vin"]];
        [detailStr appendBoldString:@"\n发动机号码: "];
        [detailStr appendLightString:dic[@"engine_no"]];
        [detailStr appendBoldString:@"\n注册日期: "];
        [detailStr appendLightString:dic[@"register_date"]];
        [detailStr appendBoldString:@"\n发证日期: "];
        [detailStr appendLightString:dic[@"issue_date"]];
        [detailStr appendBoldString:@"\n签证机关: "];
        [detailStr appendLightString:dic[@"issued_by"]];
        [detailStr appendBoldString:@"\n证件正反面: "];
        [detailStr appendLightString:@"正面"];
    }
    cell.textLabel.attributedText = detailStr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
