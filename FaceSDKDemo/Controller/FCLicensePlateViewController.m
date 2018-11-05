//
//  FCLicensePlateViewController.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/7/4.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCLicensePlateViewController.h"
#import "NSMutableAttributedString+FCExtension.h"

@interface FCLicensePlateViewController ()

@end

@implementation FCLicensePlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPOCR *ocr = [[FCPPOCR alloc] initWithImage:image];
    self.imageView.image = ocr.image;
    NSLog(@"%f",ocr.image.imageData.length/1024.0/1024.0);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ocr licensePlateCompletion:^(id info, NSError *error) {
        [hud hideAnimated:YES];
        self.tableView.contentOffset = CGPointMake(0, 0);
        [self.dataArray removeAllObjects];
        if (info) {
            [self showResult:info];
            NSArray *array = info[@"results"];
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
    NSDictionary *dic = self.dataArray[0];
    
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] init];
    [detailStr appendBoldString:@"车牌颜色: "];
    
    [detailStr appendLightString:[NSString stringWithFormat:@"%@",dic[@"color"]]];
    [detailStr appendBoldString:@"\n车牌号: "];
    [detailStr appendLightString:dic[@"license_plate_number"]];
    cell.textLabel.attributedText = detailStr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
