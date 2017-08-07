//
//  FCPPBodyManager.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/22.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCPPApi.h"

@interface FCPPBody : FCPPApi
/**
 检测人体
 中文文档:https://console.faceplusplus.com.cn/documents/7774430
 
 detect body
 English document: https://console.faceplusplus.com/documents/7774480

 @param attributes 额外返回的属性,比如gender,cloth_color
 @param completion 回调
 */
- (void)detectBodyWithAttributes:(NSArray<NSString *> *)attributes completion:(void(^)(id info,NSError *error))completion;


/**
 人像抠图,返回一张base64编码的灰度图
 中文文档:https://console.faceplusplus.com.cn/documents/7774432
 
 English document:https://console.faceplusplus.com/documents/7774482
 
 @param completion 结果回调
 */
- (void)segmentBodyCompletion:(void(^)(id info,NSError *error))completion;

@end
