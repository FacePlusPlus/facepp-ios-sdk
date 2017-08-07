//
//  FCOCRDriverLicenceViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/19.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCOCRDriverLicenceViewController.h"
#import "NSMutableAttributedString+FCExtension.h"

@interface FCOCRDriverLicenceViewController ()

@end

@implementation FCOCRDriverLicenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPOCR *ocr = [[FCPPOCR alloc] initWithImage:image];
    self.imageView.image = ocr.image;
    NSLog(@"%f",ocr.image.imageData.length/1024.0/1024.0);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ocr ocrDriverLicenseCompletion:^(id info, NSError *error) {
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
    static NSString *cellId = @"driverLicenseCellllId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fccellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] init];
    BOOL isFront = [dic[@"side"] isEqualToString:@"front"];
    
    if (isFront) {
        [detailStr appendBoldString:@"姓名: "];
        [detailStr appendLightString:dic[@"name"]];
        [detailStr appendBoldString:@"\n性别: "];
        [detailStr appendLightString:dic[@"gender"]];
        [detailStr appendBoldString:@"\n国籍: "];
        [detailStr appendLightString:dic[@"nationality"]];
        [detailStr appendBoldString:@"\n生日: "];
        [detailStr appendLightString:dic[@"birthday"]];
        [detailStr appendBoldString:@"\n住址: "];
        [detailStr appendLightString:dic[@"address"]];
        [detailStr appendBoldString:@"\n初次领证时间: "];
        [detailStr appendLightString:dic[@"issue_date"]];
        [detailStr appendBoldString:@"\n有效期限: "];
        [detailStr appendLightString:dic[@"valid_date"]];
        [detailStr appendBoldString:@"\n准驾车型: "];
        [detailStr appendLightString:dic[@"class"]];
        [detailStr appendBoldString:@"\n驾驶证号: "];
        [detailStr appendLightString:dic[@"license_number"]];
        [detailStr appendBoldString:@"\n签发机关: "];
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
