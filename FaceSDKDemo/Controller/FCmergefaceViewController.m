//
//  FCmergefaceViewController.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/1/8.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCmergefaceViewController.h"
#import "UIImage+FCExtension.h"
#import "FCPPMergeface.h"
#import "MBProgressHUD.h"

@interface FCmergefaceViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic)  UIImageView  *imageViewTemplate;///<模板图
@property (strong, nonatomic)  UIImageView  *imageViewTarget;///<要融合的人脸图
@property (strong, nonatomic)  UIImageView  *imageViewResult;///<融合结果图
@property (strong, nonatomic)  UIScrollView *contentScro;///<
@property (strong , nonatomic) UIImageView  *currentImageView;///<区分模板图和融合图
@property (strong, nonatomic)  UITextView   *textView;
@property (strong, nonatomic)  UIButton     *mergeBtn;

@end

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

@implementation FCmergefaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentScro];
    [self.contentScro addSubview: self.imageViewSource];
    [self.contentScro addSubview:self.imageViewTarget];
    [self.contentScro addSubview:self.imageViewResult];
    [self.contentScro addSubview:self.textView];
    
}

#pragma mark- UINavigationControllerDelegate,UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.currentImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.currentImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- event method
- (void)addImage:(UIButton *)sender {
    self.currentImageView = (sender.tag == 100) ? self.imageViewTemplate : self.imageViewTarget;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)beginMergeImg{
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] init];
    [hud showAnimated:YES];
    [self.view addSubview:hud];
    FCPPMergeface *template = [[FCPPMergeface alloc] initWithImage:self.imageViewTemplate.image withImageRectangle:nil];
    FCPPMergeface *merge = [[FCPPMergeface alloc] initWithImage:self.imageViewTarget.image withImageRectangle:nil];
    self.imageViewTemplate.image = template.image;
    self.imageViewTarget.image = merge.image;
    
    [template mergeWithFuseImageObj:merge withMergeRate:60 wtihCompletion:^(id info, NSError *error) {
        [hud hideAnimated:YES];
        if (error==nil) {
            if ([info isKindOfClass:[NSDictionary class]]) {
                NSString* base64_img = info[@"result"];
                if (base64_img.length) {
                    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64_img options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *image = [UIImage imageWithData:data];
                    self.imageViewResult.image = image;
                    //改变button坐标
                    self.mergeBtn.frame = CGRectMake(_imageViewResult.frame.origin.x, _imageViewResult.frame.origin.y+_imageViewResult.frame.size.height+10, _imageViewResult.frame.size.width, 44);
                }
                self.textView.text = [NSString stringWithFormat:@"time_used:%@\nrequest_id:%@",info[@"time_used"],info[@"request_id"]];
            }
            if ([info isKindOfClass:[NSString class]]){
                self.textView.text = info;
            }
        }else{
            self.textView.text = [NSString stringWithFormat:@"%@",error];
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                self.textView.text = errorStr;
            }
        }
        CGSize sizeToFit = [self.textView sizeThatFits:CGSizeMake(WIDTH, MAXFLOAT)];
        self.contentScro.contentSize = CGSizeMake(WIDTH, _textView.frame.origin.y+sizeToFit.height);
        self.textView.frame = CGRectMake(0, self.textView.frame.origin.y, WIDTH, sizeToFit.height);
    }];
}
#pragma mark- getter and setter
-(UIScrollView *)contentScro{
    if (!_contentScro) {
        _contentScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _contentScro.contentSize = CGSizeMake(WIDTH, HEIGHT);
    }
    return _contentScro;
}

-(UIImageView *)imageViewSource{
    if (!_imageViewTemplate) {
        _imageViewTemplate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2-10, HEIGHT/3)];
        _imageViewTemplate.userInteractionEnabled = YES;
        _imageViewTemplate.image = [UIImage imageNamed:@"mergefaceSource.jpg"];
        _imageViewTemplate.contentMode = UIViewContentModeScaleAspectFit;

        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _imageViewTemplate.frame.origin.y+_imageViewTemplate.frame.size.height+10, _imageViewTemplate.frame.size.width, 30)];
        btn.tag = 100;
        [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"选择模板图" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentScro addSubview:btn];
    }
    return _imageViewTemplate;
}

-(UIImageView *)imageViewTarget{
    if (!_imageViewTarget) {
        _imageViewTarget = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-_imageViewTemplate.frame.size.width, 0, _imageViewTemplate.frame.size.width, self.imageViewSource.frame.size.height)];
        _imageViewTarget.userInteractionEnabled = YES;
        _imageViewTarget.image = [UIImage imageNamed:@"mergefaceTarget.jpg"];
        _imageViewTarget.contentMode = UIViewContentModeScaleAspectFit;
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(_imageViewTarget.frame.origin.x, _imageViewTarget.frame.origin.y+_imageViewTarget.frame.size.height+10, _imageViewTarget.frame.size.width, 30)];
        btn.tag = 101;
        [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"选择融合图" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
        [self.contentScro addSubview:btn];
    }
    return _imageViewTarget;
}

-(UIImageView *)imageViewResult{
    if (!_imageViewResult) {
        _imageViewResult = [[UIImageView alloc]initWithFrame:CGRectMake(0, _imageViewTemplate.frame.origin.y+_imageViewTemplate.frame.size.height+50, WIDTH, self.imageViewSource.frame.size.height)];
        _imageViewResult.backgroundColor = [UIColor clearColor];
        _imageViewResult.contentMode = UIViewContentModeScaleAspectFit;

        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(_imageViewResult.frame.origin.x, _imageViewTarget.frame.origin.y+_imageViewTarget.frame.size.height+50, _imageViewResult.frame.size.width, 44)];
        [btn setTitle:@"开始融合" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:9.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
        [btn addTarget:self action:@selector(beginMergeImg) forControlEvents:UIControlEventTouchUpInside];
        self.mergeBtn = btn;
        [self.contentScro addSubview:btn];
    }
    return _imageViewResult;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0,_imageViewResult.frame.origin.y+_imageViewResult.frame.size.height+64, WIDTH, 100)];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}
@end

