//
//  FCBankCardViewController.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/6/29.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCBankCardViewController.h"
#import "NSMutableAttributedString+FCExtension.h"

@interface FCBankCardViewController ()

@end

@implementation FCBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPOCR *ocr = [[FCPPOCR alloc] initWithImage:image];
    self.imageView.image = ocr.image;
    NSLog(@"%f",ocr.image.imageData.length/1024.0/1024.0);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ocr ocrBankCardCompletion:^(id info, NSError *error) {
        [hud hideAnimated:YES];
        self.tableView.contentOffset = CGPointMake(0, 0);
        [self.dataArray removeAllObjects];
        if (info) {
            [self showResult:info];
            NSArray *array = info[@"bank_cards"];
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
    [detailStr appendBoldString:@"银行卡号: "];
    [detailStr appendLightString:dic[@"number"]];
    [detailStr appendBoldString:@"\n银行: "];
    [detailStr appendLightString:dic[@"bank"]];
    [detailStr appendBoldString:@"\n金融组织: "];
    //金融组织是个数组
    NSArray*orga = dic[@"organization"];
    NSMutableString* str = [NSMutableString new];
    for (NSString* strTmp in orga) {
        [str appendString:strTmp];
    }
    [detailStr appendLightString:str];
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
