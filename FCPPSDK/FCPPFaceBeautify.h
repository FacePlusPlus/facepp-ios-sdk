//
//  FCPPFaceBeautify.h
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/6/29.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCPPApi.h"

@interface FCPPFaceBeautify : FCPPApi

/**
 人脸美白与磨皮
 中文文档地址：https://console.faceplusplus.com.cn/documents/34878217

 @param ImageObj 图片对象
 @param white 美白程度
 @param smooth 磨皮程度
 @param completion 结果回调
 */
-(void)initWithImageObj:(UIImage*)ImageObj withWhite:(int)white withSmoothing:(int)smooth wtihCompletion:(void(^)(id info,NSError *error))completion;

@end
