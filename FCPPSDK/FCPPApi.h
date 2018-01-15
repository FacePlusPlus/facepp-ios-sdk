//
//  FCPPApi.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/16.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+FCExtension.h"
#import "FCPPConfig.h"

#ifdef isChina
#if isChina
#define FACE_WEB_BASE     FACE_WEB_BASE_CN
#define HUMANBODY_DETECT  HUMANBODY_DETECT_CN
#define HUMANBODY_SEGMENT HUMANBODY_SEGMENT_CN
#define IMAGE_MERGEFACE   IMAGE_MERGEFACE_CN

#else
#define FACE_WEB_BASE     FACE_WEB_BASE_US
#define HUMANBODY_DETECT  HUMANBODY_DETECT_US
#define HUMANBODY_SEGMENT HUMANBODY_SEGMENT_US
#define IMAGE_MERGEFACE   IMAGE_MERGEFACE_US
#endif
#endif

#pragma mark- api

//base url for China
static NSString * FACE_WEB_BASE_CN = @"https://api-cn.faceplusplus.com/facepp/v3";

//base url for other country
static NSString * FACE_WEB_BASE_US = @"https://api-us.faceplusplus.com/facepp/v3";

static NSString * FACE_DETECT  = @"detect";
static NSString * FACE_COMPARE = @"compare";
static NSString * FACE_SEARCH  = @"search";


static NSString * FACETOEKN = @"face";
static NSString * FACETOEKN_ANALYZE    = @"analyze";
static NSString * FACETOEKN_SET_USERID = @"setuserid";
static NSString * FACETOEKN_GET_DETAIL = @"getdetail";

//faceSet
static NSString * FACESET = @"faceset";
static NSString * FACESET_CREATE  = @"create";
static NSString * FACESET_ADDFACE = @"addface";
static NSString * FACESET_REMOVE_FACE = @"removeface";
static NSString * FACESET_UPDATE = @"update";
static NSString * FACESET_GET_DETAIL = @"getdetail";
static NSString * FACESET_GET_FACESETS = @"getfacesets";
static NSString * FACESET_DELETE  = @"delete";

//人体检测和人体抠图
static NSString * HUMANBODY_DETECT_CN  = @"https://api-cn.faceplusplus.com/humanbodypp/beta/detect";
static NSString * HUMANBODY_SEGMENT_CN = @"https://api-cn.faceplusplus.com/humanbodypp/beta/segment";

static NSString * HUMANBODY_DETECT_US = @"https://api-us.faceplusplus.com/humanbodypp/beta/detect";
static NSString * HUMANBODY_SEGMENT_US = @"https://api-us.faceplusplus.com/humanbodypp/beta/segment";

//OCR 识别身份证/驾驶证/行驶证/文字/场景物体,Only for china
static NSString * OCR_CN = @"https://api-cn.faceplusplus.com/cardpp/v1";
static NSString * OCR_CARD = @"ocridcard";
static NSString * OCR_DRIVER_LICENSE = @"ocrdriverlicense";
static NSString * OCR_VEHICLE_LICENSE = @"ocrvehiclelicense";

static NSString * IMAGE_CN = @"https://api-cn.faceplusplus.com/imagepp";
static NSString * IMAGE_Object = @"beta/detectsceneandobject";
static NSString * IMAGE_Text = @"v1/recognizetext";
static NSString * IMAGE_Text_Beta = @"beta/recognizetext";

//图像识别之图像融合
static NSString * IMAGE_MERGEFACE_CN = @"https://api-cn.faceplusplus.com/imagepp/v1/";
static NSString * IMAGE_MERGEFACE_US = @"https://api-us.faceplusplus.com/imagepp/v1/";
static NSString * MERGEFACE = @"mergeface";

@interface FCPPApi : NSObject
/**
 *  图片的网络地址
 *  The image URL
 */
@property (copy , nonatomic) NSString  *imageUrl;

@property (strong , nonatomic) UIImage *image;

- (instancetype)initWithImageUrl:(NSString *)imageUrl;

- (instancetype)initWithImage:(UIImage *)image;

/**
 POST请求

 @param url 请求地址
 @param dic 参数
 @param completion 请求结果
 */
+ (void)POST:(NSString *)url param:(NSDictionary *)dic completion:(void(^)(id info,NSError *error))completion;
@end
