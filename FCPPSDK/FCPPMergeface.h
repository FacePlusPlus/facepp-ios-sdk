//
//  FCPPMergeface.h
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/1/9.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCPPApi.h"

@interface FCPPMergeface : FCPPApi

@property(copy, nonatomic)NSString*       imageRectangle;///<图片中人脸框位置，如@“234,456,456,356”,分别表示人脸框在图片中的x,y,width,height坐标

/**
 对模板图和融合图中的人脸进行融合操作
 中文文档地址:https://console.faceplusplus.com.cn/documents/20813963
 
 Fusion operation of image in template and face image.
 English document:https://console.faceplusplus.com/documents/20815649

 初始化对象
 @param image 图片对象
 @param ImageRectangle 图片人脸框位置，如@“234,456,456,356”,分别表示人脸框在图片中的x,y,width,height坐标,当image表示融合图时候，如果该字段为nil时，则不上传该参数，如果无效时返回错误；当image表示模板图时，如果该字段为nil时，则默认会调用人脸检测再进行人脸融合，如果无效时返回错误。
 @return 当前对象
 */
-(instancetype)initWithImage:(UIImage*)image withImageRectangle:(NSString*)ImageRectangle;


/**
 由模板图生成的对象调用该方法和融合图进行融合

 @param fuseImageObj 融合图对象
 @param mergeRate 融合比例，范围 [0,100]。数字越大融合结果包含越多融合图,当该值无效时，默认为50
 @param completion 结果回调
 */
-(void)mergeWithFuseImageObj:(FCPPMergeface*)fuseImageObj withMergeRate:(int)mergeRate wtihCompletion:(void(^)(id info,NSError *error))completion;

@end
