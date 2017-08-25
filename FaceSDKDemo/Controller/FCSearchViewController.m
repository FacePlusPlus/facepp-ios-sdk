//
//  FCAddFaceViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/4.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCSearchViewController.h"
#import "FCPPSDK.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"

static NSString *cellId = @"faceCellId";
#define faceFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"face.plist"]

@interface FCSearchViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong , nonatomic) FCPPFaceSet *faceSet;

@property (strong , nonatomic) NSMutableDictionary *faceMap;

@property (strong , nonatomic) NSMutableArray *dataArray;

@property (assign , nonatomic) BOOL addFace;

@property (assign , nonatomic) NSInteger faceIndex;
@end

//人脸搜索流程如下:
//1.创建一个faceset,用来存放facetoken
//2.检测一张照片,获取到facetoken,并在自己服务器上建立token与人,图片的映射关系
//3.添加facetoken到faceset中
//4.搜索,从搜索库中找出一张与需要查找的图片最像似的图片
//5.根据第二部的映射关系拿到facetoken对应的图片以及个人信息

//注意事项:
//1.faceset做多容纳1000个facetoken,注意判断是否满了
//2.搜索到的只是最像似的人脸,不一定是一个人,需要加上阈值判断,见下面代码
//3.待搜索的照片有多个人脸时,选择最大的检测

@implementation FCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faceIndex = -1;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    //1.创建人脸集合
    NSString *outerId = @"myFaceSet";//设置自定义标记
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在创建人脸集合...";
    [FCPPFaceSet createFaceSetWithDisplayName:@"人脸搜索" outerId:outerId tgas:nil faceTokens:nil userData:nil forceMerge:YES completion:^(id info, NSError *error) {
        if (error == nil) {
            hud.label.text = @"创建人脸集合完成";
            [hud hideAnimated:YES afterDelay:1.0];
            self.faceSet = [[FCPPFaceSet alloc] initWithOuterId:outerId];
        }else{
            hud.label.text = @"人脸集合创建失败,请重新进入";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.addFace) {
            [self addImage:image];
        }else{
            [self searchImage:image];
        }
    }];
}

- (void)addImage:(UIImage *)image{
    
    __weak typeof(self) weakSelf = self;
    
    self.imageView.image = image;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在检测人脸...";
    //2.0检测人脸
    FCPPFaceDetect *faceDetector = [[FCPPFaceDetect alloc] initWithImage:image];
    [faceDetector detectFaceWithReturnLandmark:NO attributes:nil completion:^(id info, NSError *error) {
        if (error) {
            hud.label.text = @"人脸检测失败,请重新添加";
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            hud.label.text = @"正在添加到人脸集合...";
            NSArray *faceTokens = [info[@"faces"] valueForKeyPath:@"face_token"];

            //3.添加到人脸集合
            if (faceTokens.count && weakSelf.faceSet) {
                [weakSelf.faceSet addFaceTokens:faceTokens completion:^(id info, NSError *error) {
                    if (error == nil) {
                        //2.1建立映射关系
                        for (NSString *faceToken in faceTokens) {
                            //把图片存储到本地，faceToken作为key存储图片
                            [[SDImageCache sharedImageCache] storeImage:image forKey:faceToken];
                           
                            NSDictionary *dic = @{@"imageKey": faceToken,  //对应的本地的图片
//                                                  @"personName" : @"xxx", //设置对应人的名字
                                                    @"" : @"",              //其他自定义对应的信息
                                                 };
                            [weakSelf.faceMap setObject:dic forKey:faceToken];//建立映射
                            [weakSelf.dataArray addObject:faceToken];
                        }
                        [weakSelf.faceMap writeToFile:faceFilePath atomically:YES];
                        [weakSelf.collectionView reloadData];
                        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                        hud.label.text = @"添加成功";
                    }else{
                        hud.label.text = @"添加失败";
                    }
                    [hud hideAnimated:YES afterDelay:1.5];
                }];
            }else{
                hud.label.text = @"添加失败";
                [hud hideAnimated:YES afterDelay:1.5];
            }
        }
    }];
}
- (void)searchImage:(UIImage *)image{
    self.imageView.image = image;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在搜索....";
    FCPPFace *face = [[FCPPFace alloc] initWithImage:image];
    self.faceIndex = -1;
    //4.搜索
    [face searchFromFaceSet:self.faceSet returnCount:1 completion:^(id info, NSError *error) {
        if (info) {
            NSArray *faces = info[@"faces"];
            if (faces.count) {
                [hud hideAnimated:YES];
                NSDictionary *result = [info[@"results"] firstObject];
                NSDictionary *thresholds = info[@"thresholds"];
                NSString *faceToken = result[@"face_token"];
                CGFloat confidence = [result[@"confidence"] floatValue];
                CGFloat maxThreshold = [thresholds[@"1e-5"] floatValue];
                CGFloat midThreshold = [thresholds[@"1e-4"] floatValue];
                CGFloat minThreshold = [thresholds[@"1e-3"] floatValue];
                
                BOOL vaild = confidence > midThreshold;//置信度大于阈值,才算搜到的是一个人
                if (faceToken && vaild) {//搜索到人脸
                    NSLog(@"%@",faceToken);
                    //5.根据faceToken的映射关系,取出相应信息
                    if ([self.dataArray containsObject:faceToken]) {
                        NSInteger index = [self.dataArray indexOfObject:faceToken];
                        self.faceIndex = index;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    }
                }else{
                    hud.label.text = @"没有搜索到合适的人脸";
                    [hud hideAnimated:YES afterDelay:1.0];
                }
            }else{
                hud.label.text = @"没有检测到人脸";
                [hud hideAnimated:YES afterDelay:1.0];
            }
        }else{
            hud.label.text = @"网络请求失败";
            [hud hideAnimated:YES afterDelay:1.0];
        }
        [self.collectionView reloadData];
    }];
}
- (IBAction)addFace:(UIButton *)sender {
    self.addFace = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)addSearchImage:(UIButton *)sender {
    self.addFace = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *faceToken = self.dataArray[indexPath.item];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:faceToken];
    cell.backgroundView = imageView;
    if (indexPath.item == self.faceIndex) {
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        imageView.layer.borderWidth = 2;
    }else{
        imageView.layer.borderWidth = 0;
    }
    return cell;
}

- (NSMutableDictionary *)faceMap{
    if (_faceMap == nil) {
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:faceFilePath].mutableCopy;
    }
    
    if (_faceMap == nil) {
        _faceMap = [NSMutableDictionary dictionary];
    }
    return _faceMap;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = self.faceMap.allKeys.mutableCopy;
    }
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
