//
//  FCCompareViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/29.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCCompareViewController.h"
#import "MBProgressHUD.h"
#import "FCPPSDK.h"

@interface FCCompareViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong , nonatomic) UIImageView *currentImageView;
@end

@implementation FCCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView1.image = [UIImage imageNamed:@"sunli-1"];
    self.imageView2.image = [UIImage imageNamed:@"sunli-2"];
    [self begainCompare:nil];
}

- (IBAction)begainCompare:(UIButton *)sender {
    [self.imageView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageView2.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    FCPPFace *face1 = [[FCPPFace alloc] initWithImage:self.imageView1.image];
    FCPPFace *face2 = [[FCPPFace alloc] initWithImage:self.imageView2.image];
    self.imageView1.image = face1.image;
    self.imageView2.image = face2.image;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [face1 compareFaceWithOther:face2 completion:^(id info, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (info) {
            NSArray *face1 = info[@"faces1"];
            NSArray *face2 = info[@"faces2"];
            if (face1.count == 0) {
                self.textView.text = @"图片1没有检测到人脸";
                return ;
            }
            if(face2.count == 0){
                self.textView.text = @"图片2没有检测到人脸";
                return;
            }
            
            NSNumber *confidence = info[@"confidence"];
            NSDictionary *thresholds = info[@"thresholds"];
            NSMutableString *string = [NSMutableString string];
            [string appendFormat:@"置信度: %@\n",confidence];
            [string appendFormat:@"不同误识率下的置信度阈值:\n"];
            [thresholds enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [string appendFormat:@"%@ : %@\n",key,obj];
            }];
            
            [string appendString:@"\n比对结果:\n"];
            
            CGFloat confidenceValue = confidence.floatValue;
            CGFloat maxThreshold = [thresholds[@"1e-5"] floatValue];
            CGFloat midThreshold = [thresholds[@"1e-4"] floatValue];
            CGFloat minThreshold = [thresholds[@"1e-3"] floatValue];
            
            //用户可根据自己的业务场景,选择不同的阈值.要求严格选择max,宽松则选择min
            if (confidenceValue >= maxThreshold) {
                [string appendString:@"是否是同一个人: 可能性高"];
            }else if (confidenceValue <= minThreshold){
                [string appendString:@"是否是同一个人: 可能性低"];
            }else{
                [string appendString:@"是否是同一个人: 可能性一般"];
            }
            self.textView.text = string;
            
            [self handleWithImageView:self.imageView1 withInfo:info[@"faces1"]];
            [self handleWithImageView:self.imageView2 withInfo:info[@"faces2"]];
        }else{
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                self.textView.text = errorStr;
            }else{
                self.textView.text = @"网络请求失败";
            }
        }
    }];
}
- (void)handleWithImageView:(UIImageView *)imageView withInfo:(NSArray *)array{
    UIImage *image = imageView.image;
    
    CGFloat scaleH = imageView.bounds.size.width / image.size.width;
    CGFloat scaleV = imageView.bounds.size.height / image.size.height;
    CGFloat scale = scaleH < scaleV ? scaleH : scaleV;
    CGFloat offsetX = image.size.width*(scaleH - scale)*0.5;
    CGFloat offsetY = image.size.height*(scaleV - scale)*0.5;
    
    for (NSDictionary *dic in array) {
        NSDictionary *rect = dic[@"face_rectangle"];
        CGFloat angle = [dic[@"attributes"][@"headpose"][@"roll_angle"] floatValue];
        NSLog(@"%@",rect);
        CGFloat x = [rect[@"left"] floatValue];
        CGFloat y = [rect[@"top"] floatValue];
        CGFloat w = [rect[@"width"] floatValue];
        CGFloat h = [rect[@"height"] floatValue];
        
        UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, h*scale)];
        rectView.transform = CGAffineTransformMakeRotation(angle/360.0 *2*M_PI);
        rectView.layer.borderColor = [UIColor greenColor].CGColor;
        rectView.layer.borderWidth = 1;
        [imageView addSubview:rectView];
    }
    
}

- (IBAction)addImage:(UIButton *)sender {
    self.currentImageView = (sender.tag == 1) ? self.imageView1 : self.imageView2;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.currentImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
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
