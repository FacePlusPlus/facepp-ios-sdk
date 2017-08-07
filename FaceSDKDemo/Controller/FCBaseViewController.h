//
//  FCBaseViewController.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/10.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCPPSDK.h"
#import "MBProgressHUD.h"

@interface FCBaseViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) UIImage *image;

@property (strong , nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic)  UIImageView *imageView;

@property (strong, nonatomic)  UITableView *tableView;

- (void)handleImage:(UIImage *)image;
- (void)showResult:(id)result;
- (void)showError:(NSError *)error;
- (void)showContent:(NSString *)content;
@end
