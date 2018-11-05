//
//  FCBeautifyViewController.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/6/29.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCBeautifyViewController.h"
#import "FCPPFaceBeautify.h"

@interface FCBeautifyCell : UITableViewCell
@property (strong , nonatomic) UIImageView *imageV;
@end

@implementation FCBeautifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-10*2, [UIScreen mainScreen].bounds.size.height*.5)];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _imageV.clipsToBounds = YES;
        [self addSubview:_imageV];
    }
    return self;
}

- (void)setFaceInfoWithBase64:(NSString *)beautifyInfo{
   
    NSString* base64_img = beautifyInfo;
    if (base64_img.length) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64_img options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:data];
        _imageV.image = image;
    }
}

@end


@interface FCBeautifyViewController ()
@end

@implementation FCBeautifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.imageView.image = image;
    [[FCPPFaceBeautify alloc]initWithImageObj:image withWhite:100 withSmoothing:100 wtihCompletion:^(id info, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"info = %@",info);
        
        [self.dataArray removeAllObjects];
        if (info) {
            [self showResult:info];
            NSString *base64 = info[@"result"];
            [self.dataArray addObject:base64];
        }else{
            [self showError:error];
        }
        [self.tableView reloadData];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenfify = @"faceBeautify";
    FCBeautifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfify];
    if (cell == nil) {
        cell = [[FCBeautifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *base64 = self.dataArray[0];
    [cell setFaceInfoWithBase64:base64];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
