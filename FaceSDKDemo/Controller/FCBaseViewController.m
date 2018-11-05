//
//  FCBaseViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/10.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCBaseViewController.h"
#import "FCPPSDK.h"

@interface FCBaseViewController ()

@end

@implementation FCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改图片" style:UIBarButtonItemStylePlain target:self action:@selector(changeImage)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-10*2, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height *0.5)];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, bgView.bounds.size.width, bgView.bounds.size.height -10*2)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:self.imageView];
    
    self.tableView.tableHeaderView = bgView;
    [self.view addSubview:self.tableView];
}

- (void)changeImage{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"修改图片" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
    [alertVC addAction:libAction];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
    [alertVC addAction:cameraAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self handleImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleImage:(UIImage *)image{
    //子类重写
}

- (void)showResult:(id)result{
    if (result) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self showContent:str];
    }
}

- (void)showError:(NSError *)error{
    NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if (errorData) {
        NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        [self showContent:errorStr];
    }else{
         [self showContent:@"网络请求失败"];
    }
}

- (void)showContent:(NSString *)content{
    if (content.length == 0) {
        self.tableView.tableFooterView = [[UIView alloc] init];
        return;
    }
    
    UITextView* textView = [UITextView new];
    textView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
    textView.text = content;
    [textView sizeToFit];
    
    self.tableView.tableFooterView = textView;
}
#pragma mark- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width, 24)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.text = @"检测结果:";
    return label;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width, 24)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.text = @"JSON字符串:";
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
