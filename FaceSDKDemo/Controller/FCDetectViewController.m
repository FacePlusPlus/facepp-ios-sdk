//
//  FCDetectViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/27.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCDetectViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+FCExtension.h"

@interface FaceCell : UITableViewCell
@property (strong , nonatomic) UIImage *fullImage;
@property (strong , nonatomic) NSDictionary *faceInfo;
@end

@implementation FaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return self;
}

- (void)setFaceInfo:(NSDictionary *)faceInfo{
    _faceInfo = faceInfo;
    //分析数据
    NSDictionary *rect = faceInfo[@"face_rectangle"];
    //裁剪出人脸
    CGFloat x = [rect[@"left"] floatValue];
    CGFloat y = [rect[@"top"] floatValue];
    CGFloat w = [rect[@"width"] floatValue];
    CGFloat h = [rect[@"height"] floatValue];
    self.imageView.image = [self.fullImage cropWithRect:CGRectMake(x, y, w, h)];
    
    //获取属性
    NSDictionary *att = faceInfo[@"attributes"];
    NSMutableString *detailStr = [NSMutableString string];
    
    NSString *value = nil;
    value = att[@"gender"][@"value"];
    [detailStr appendFormat:@"性别: %@",value];
    
    value = att[@"age"][@"value"];
    [detailStr appendFormat:@"\n年龄: %@",value];
    
    value = [self largeKeyWith:att[@"smile"]];
    NSString *score = att[@"smile"][@"value"];
    
    if ([value isEqualToString:@"value"]) {
        value = [NSString stringWithFormat:@"\n微笑分数: %.2f,是否微笑: 是",score.floatValue];
    }else{
        value = [NSString stringWithFormat:@"\n微笑分数: %.2f,是否微笑: 否",score.floatValue];
    }
    [detailStr appendFormat:@"\n%@",value];
    NSDictionary *emotionDic = att[@"emotion"];
    value = [self largeKeyWith:emotionDic];
    [detailStr appendFormat:@"\n表情: %@",value];
    
    value = att[@"ethnicity"][@"value"];
    [detailStr appendFormat:@"\n人种: %@",value];
    
    NSDictionary *temp = att[@"eyestatus"][@"left_eye_status"];
    NSDictionary *eyeDic = @{@"occlusion" : @"眼睛被遮挡",
                             @"no_glass_eye_open" : @"不戴眼镜且睁眼",
                             @"normal_glass_eye_close" : @"佩戴普通眼镜且闭眼",
                             @"normal_glass_eye_open" : @"佩戴普通眼镜且睁眼",
                             @"dark_glasses" : @"佩戴墨镜",
                             @"no_glass_eye_close" : @"不戴眼镜且闭眼"};
    value = [self largeKeyWith:temp];
    [detailStr appendFormat:@"\n左眼状态: %@",eyeDic[value]];
    
    temp = att[@"eyestatus"][@"right_eye_status"];
    value = [self largeKeyWith:temp];
    [detailStr appendFormat:@"\n右眼状态: %@",eyeDic[value]];
    
    temp = att[@"headpose"];
    [detailStr appendFormat:@"\n抬头角度: %@",temp[@"pitch_angle"]];
    [detailStr appendFormat:@"\n平面旋转角度: %@",temp[@"roll_angle"]];
    [detailStr appendFormat:@"\n左右摇头角度: %@",temp[@"yaw_angle"]];
    
    value = [self largeKeyWith:att[@"facequality"]];
    score = att[@"facequality"][@"value"];
    if ([value isEqualToString:@"value"]) {
        value = [NSString stringWithFormat:@"人脸质量分数: %.2f, 可以用做人脸比对",score.floatValue];
    }else{
        value = [NSString stringWithFormat:@"人脸质量分数: %.2f, 不建议用做人脸比对",score.floatValue];
    }
    [detailStr appendFormat:@"\n%@",value];
    
    self.detailTextLabel.text = detailStr;
}

//取出value值最大的对应的key
- (NSString *)largeKeyWith:(NSDictionary *)dic{
    __block NSString *largeKey = nil;
    __block CGFloat maxValue = 0;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > maxValue) {
            maxValue = [obj floatValue];
            largeKey = key;
        }
    }];
    return largeKey;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 5, 50, 50);
    self.detailTextLabel.frame = CGRectMake(60, 5, self.bounds.size.width - 55 - 5, self.bounds.size.height - 10);
}

@end


@interface FCDetectViewController ()

@end

@implementation FCDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}

- (void)handleImage:(UIImage *)image{
    //清除人脸框
    [self.imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //检测人脸
    FCPPFaceDetect *faceDetect = [[FCPPFaceDetect alloc] initWithImage:image];
    self.imageView.image = faceDetect.image;
    self.image = faceDetect.image;
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //需要获取的属性
    NSArray *att = @[@"gender",@"age",@"headpose",@"smiling",@"blur",@"eyestatus",@"emotion",@"facequality",@"ethnicity"];
    [faceDetect detectFaceWithReturnLandmark:YES attributes:att completion:^(id info, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.tableView.contentOffset = CGPointMake(0, -64);
        [weakSelf.dataArray removeAllObjects];

        if (info) {
            NSArray *array = info[@"faces"];
            if (array.count) {
                UIImage *image = faceDetect.image;

                //绘制关键点和矩形框
                [weakSelf handleImage:image withInfo:array];
                
                //显示每个人脸的详细信息
                [weakSelf.dataArray addObjectsFromArray:array];
                //显示json
                [weakSelf showResult:info];
            }else{
                [weakSelf showContent:@"没有检测到人脸"];
            }
        }else{
            [weakSelf showError:error];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)handleImage:(UIImage *)image withInfo:(NSArray *)array{
    
    CGFloat scaleH = self.imageView.bounds.size.width / image.size.width;
    CGFloat scaleV = self.imageView.bounds.size.height / image.size.height;
    CGFloat scale = scaleH < scaleV ? scaleH : scaleV;
    CGFloat offsetX = image.size.width*(scaleH - scale)*0.5;
    CGFloat offsetY = image.size.height*(scaleV - scale)*0.5;

    //绘制矩形框
    for (NSDictionary *dic in array) {
        NSDictionary *rect = dic[@"face_rectangle"];
        CGFloat angle = [dic[@"attributes"][@"headpose"][@"roll_angle"] floatValue];
       
        CGFloat x = [rect[@"left"] floatValue];
        CGFloat y = [rect[@"top"] floatValue];
        CGFloat w = [rect[@"width"] floatValue];
        CGFloat h = [rect[@"height"] floatValue];
        
        UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, h*scale)];
        rectView.transform = CGAffineTransformMakeRotation(angle/360.0 *2*M_PI);
        rectView.layer.borderColor = [UIColor greenColor].CGColor;
        rectView.layer.borderWidth = 1;

        [self.imageView addSubview:rectView];
    }
    
    //绘制关键点
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSDictionary *dic in array) {
        NSArray *dicArr = [dic[@"landmark"] allValues];
        for (NSDictionary *p in dicArr) {
            CGFloat x = [p[@"x"] floatValue];
            CGFloat y = [p[@"y"] floatValue];
            
            [[UIColor blueColor] set];
            CGContextAddArc(context, x, y, 1/scale, 0, 2*M_PI, 0);
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = temp;
}

#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"faceCellId";
    FaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[FaceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.fullImage = self.image;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.faceInfo = dic;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 242;
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
