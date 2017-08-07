//
//  FCPPFaceDetector.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/18.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPApi.h"

@interface FCPPFaceDetect : FCPPApi

#pragma mark- 人脸检测(face detect)
/**
 检测一张图片并获取人脸信息
 中文文档地址:https://console.faceplusplus.com.cn/documents/4888373
 
 Detect a image and get the face info.
 English document:https://console.faceplusplus.com/documents/5679127
 
 @param return_landmark 是否返回人脸关键点
 @param attributes 需要返回的人脸特征,填写下面的中的一个或多个:gender, age, smiling, headpose, facequality, blur, eyestatus, emotion, ethnicity
 */
- (void)detectFaceWithReturnLandmark:(BOOL)return_landmark attributes:(NSArray<NSString *> *)attributes completion:(void(^)(id info,NSError *error))completion;
@end
