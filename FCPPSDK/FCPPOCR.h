//
//  FCPPOCRManager.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/22.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCPPApi.h"

/**
 *  Only for China,please ignore if you are use international version
 */
@interface FCPPOCR : FCPPApi


/**
 身份证识别 https://console.faceplusplus.com.cn/documents/5671702

 @param completion 结果回调
 */
- (void)ocrIDCardCompletion:(void(^)(id info,NSError *error))completion;

/**
 机动车驾驶证识别 https://console.faceplusplus.com.cn/documents/5671704
 
 @param completion 结果回调
 */
- (void)ocrDriverLicenseCompletion:(void(^)(id info,NSError *error))completion;

/**
 机动车行驶证识别 https://console.faceplusplus.com.cn/documents/5671706
 
 @param completion 结果回调
 */
- (void)ocrVehicleLicenseCompletion:(void(^)(id info,NSError *error))completion;

/**
 文字识别 https://console.faceplusplus.com.cn/documents/7776484
 
 @param completion 结果回调
 */
- (void)ocrTextCompletion:(void(^)(id info,NSError *error))completion;

/**
 文字识别beta版 https://console.faceplusplus.com.cn/documents/5671710
 
 @param completion 结果回调
 */
- (void)ocrTextBetaCompletion:(void(^)(id info,NSError *error))completion;

/**
 场景物体识别 https://console.faceplusplus.com.cn/documents/5671708
 
 @param completion 结果回调
 */
- (void)detectSceneAndObjectCompletion:(void(^)(id info,NSError *error))completion;

@end
