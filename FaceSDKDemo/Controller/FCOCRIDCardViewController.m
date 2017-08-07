//
//  FCOCRIDCardViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/19.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCOCRIDCardViewController.h"
#import "NSMutableAttributedString+FCExtension.h"

@interface FCOCRIDCardViewController ()

@end

@implementation FCOCRIDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPOCR *ocr = [[FCPPOCR alloc] initWithImage:image];
    self.imageView.image = ocr.image;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ocr ocrIDCardCompletion:^(id info, NSError *error) {
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
    static NSString *cellId = @"IDCardCellllId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fccellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] init];
    
    BOOL isBack = [dic[@"side"] isEqualToString:@"back"];
    if (isBack) {
        [detailStr appendBoldString:@"签发机关: "];
        [detailStr appendLightString:dic[@"issued_by"]];
        [detailStr appendBoldString:@"\n\n有效日期: "];
        [detailStr appendLightString:dic[@"valid_date"]];
        [detailStr appendBoldString:@"\n\n证件正反面: "];
        [detailStr appendLightString:@"国徽面"];
    }else{
        [detailStr appendBoldString:@"姓名: "];
        [detailStr appendLightString:dic[@"name"]];
        [detailStr appendBoldString:@"\n性别: "];
        [detailStr appendLightString:dic[@"gender"]];
        [detailStr appendBoldString:@"\n民族: "];
        [detailStr appendLightString:dic[@"race"]];
        [detailStr appendBoldString:@"\n出生: "];
        [detailStr appendLightString:dic[@"birthday"]];
        [detailStr appendBoldString:@"\n住址: "];
        [detailStr appendLightString:dic[@"address"]];
        [detailStr appendBoldString:@"\n公民身份证号: "];
        [detailStr appendLightString:dic[@"id_card_number"]];
        [detailStr appendBoldString:@"\n证件正反面: "];
        [detailStr appendLightString:@"人像面"];
    }

    //正式key,可判断身份证真实性.
//    [detailStr appendBoldString:@"\n证件照片真实性: "];

    cell.textLabel.attributedText = detailStr;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 222;
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
