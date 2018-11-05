//
//  FCBodyViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/10.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCBodyDetectViewController.h"
#import "UIImage+FCExtension.h"


@interface FCBodyCell : UITableViewCell
@property (strong , nonatomic) UIImage *image;
@property (strong , nonatomic) NSDictionary *bodyInfo;

@property (strong , nonatomic) UILabel *upLabel;
@property (strong , nonatomic) UIView  *upColorView;
@property (strong , nonatomic) UILabel *downLabel;
@property (strong , nonatomic) UIView  *downColorView;
@end

@implementation FCBodyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.upLabel];
        [self.contentView addSubview:self.upColorView];
        [self.contentView addSubview:self.downLabel];
        [self.contentView addSubview:self.downColorView];
    }
    return self;
}

- (void)setBodyInfo:(NSDictionary *)bodyInfo{
    _bodyInfo = bodyInfo;
    //分析数据
    NSDictionary *rect = bodyInfo[@"humanbody_rectangle"];
    //裁剪出人脸
    CGFloat x = [rect[@"left"] floatValue];
    CGFloat y = [rect[@"top"] floatValue];
    CGFloat w = [rect[@"width"] floatValue];
    CGFloat h = [rect[@"height"] floatValue];
    self.imageView.image = [self.image cropWithRect:CGRectMake(x, y, w, h)];
    
    NSDictionary *att = bodyInfo[@"attributes"];
    NSMutableString *detailStr = [NSMutableString string];
    NSString *value = nil;
    value = att[@"gender"][@"value"];
    [detailStr appendFormat:@"性别: %@\n",value];
    self.detailTextLabel.text = detailStr;
    
    CGFloat upR = [att[@"upper_body_cloth_color_rgb"][@"r"] floatValue];
    CGFloat upG = [att[@"upper_body_cloth_color_rgb"][@"g"] floatValue];
    CGFloat upB = [att[@"upper_body_cloth_color_rgb"][@"b"] floatValue];
    self.upColorView.backgroundColor = [UIColor colorWithRed:upR/255.0 green:upG/255.0 blue:upB/255.0 alpha:1.0];
    
    CGFloat downR = [att[@"lower_body_cloth_color_rgb"][@"r"] floatValue];
    CGFloat downG = [att[@"lower_body_cloth_color_rgb"][@"g"] floatValue];
    CGFloat downB = [att[@"lower_body_cloth_color_rgb"][@"b"] floatValue];
    self.downColorView.backgroundColor = [UIColor colorWithRed:downR/255.0 green:downG/255.0 blue:downB/255.0 alpha:1.0];
    
}
- (UILabel *)upLabel{
    if (_upLabel == nil) {
        _upLabel = [[UILabel alloc] init];
        _upLabel.text = @"上半身衣服颜色:";
        _upLabel.textColor = [UIColor grayColor];
        _upLabel.font = self.detailTextLabel.font;
    }
    return _upLabel;
}
- (UIView *)upColorView{
    if (_upColorView == nil) {
        _upColorView = [[UIView alloc] init];
    }
    return _upColorView;
}
- (UILabel *)downLabel{
    if (_downLabel == nil) {
        _downLabel = [[UILabel alloc] init];
        _downLabel.textColor = [UIColor grayColor];
        _downLabel.text = @"下半身衣服颜色:";
        _downLabel.font = self.detailTextLabel.font;
    }
    return _downLabel;
}
- (UIView *)downColorView{
    if (_downColorView == nil) {
        _downColorView = [[UIView alloc] init];
    }
    return _downColorView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.contentView.bounds.size.width*0.5;
    CGFloat h = self.contentView.bounds.size.height - 10;
    CGFloat labelX = w + 10;
    CGFloat labelH = 22;
    CGFloat labelW = w - 10;
    self.imageView.frame = CGRectMake(0, 5, w, h);
    self.detailTextLabel.frame = CGRectMake(labelX, 5, labelW, labelH);
    
    CGFloat bottom = 5 + labelH;
    self.upLabel.frame = CGRectMake(labelX, bottom+10, labelW, labelH);
    bottom = bottom + 10 + labelH;
    self.upColorView.frame = CGRectMake(labelX, bottom, labelW, 30);
    
    bottom = bottom + 30;
    self.downLabel.frame = CGRectMake(labelX, bottom+10, labelW, labelH);
    bottom = bottom + 10 +labelH;
    self.downColorView.frame = CGRectMake(labelX, bottom, labelW, 30);
}
@end

@interface FCBodyDetectViewController ()
@property (strong , nonatomic) FCPPBody *bodyDetector;
@end

@implementation FCBodyDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleImage:self.image];
}


- (void)handleImage:(UIImage *)image{
    [self.imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    FCPPBody *bodyDetector = [[FCPPBody alloc] initWithImage:image];
    self.bodyDetector = bodyDetector;
    self.imageView.image = bodyDetector.image;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [bodyDetector detectBodyWithAttributes:@[@"gender",@"cloth_color"] completion:^(id info, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tableView.contentOffset = CGPointMake(0, -64);
        [self.dataArray removeAllObjects];
        
        NSArray *array = info[@"humanbodies"];
        NSMutableArray *arrayM = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"confidence"] floatValue] >= 75.0) {//认为小于这个范围的不是人体
                [arrayM addObject:obj];
            }
        }];
        
        UIImage *image = bodyDetector.image;

        if (arrayM.count) {
            //绘制关键点和矩形框
            [self handleImage:image withInfo:arrayM];
            
            //显示每个人体的详细信息
            [self.dataArray addObjectsFromArray:arrayM];
        }
        [self.tableView reloadData];//无数据也需要刷新列表，原因：如果上传不合格照片，那么在滑动列表时会崩溃，因为这个时候self.dataArray是没有数据的
        //显示JSON
        if (info) {
            [self showResult:info];
        }else{
            [self showError:error];
        }
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
        NSDictionary *rect = dic[@"humanbody_rectangle"];
        CGFloat x = [rect[@"left"] floatValue];
        CGFloat y = [rect[@"top"] floatValue];
        CGFloat w = [rect[@"width"] floatValue];
        CGFloat h = [rect[@"height"] floatValue];
        
        UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, h*scale)];
        rectView.layer.borderColor = [UIColor greenColor].CGColor;
        rectView.layer.borderWidth = 1;
        
        [self.imageView addSubview:rectView];
    }
}

#pragma mark- tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"bodyDetectCellllId";
    FCBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fccellId"];
    if (cell == nil) {
        cell = [[FCBodyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image = self.bodyDetector.image;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.bodyInfo = dic;
    
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
