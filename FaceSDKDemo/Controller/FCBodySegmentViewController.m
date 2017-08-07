//
//  FCBodySegmentViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/18.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCBodySegmentViewController.h"
#import "UIImage+FCExtension.h"

@interface FCBodySegmentViewController ()

@end

@implementation FCBodySegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    FCPPBody *body = [[FCPPBody alloc] initWithImage:image];
    self.imageView.image = body.image;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [body segmentBodyCompletion:^(id info, NSError *error) {
        [hud hideAnimated:YES];
        if (info) {
            NSString *base64Str = info[@"result"];
            if (base64Str.length) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *image = [UIImage imageWithData:data];
                //抠图
                self.imageView.image = [body.image blendWithGrayImage:image backgroudColor:0xFFFFFF];
            }
            [self showResult:info];
        }else{
            [self showError:error];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
