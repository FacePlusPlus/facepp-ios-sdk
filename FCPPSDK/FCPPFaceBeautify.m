//
//  FCPPFaceBeautify.m
//  FaceSDKDemo
//
//  Created by Yuan Le on 2018/6/29.
//  Copyright © 2018年 Yang Yunxing. All rights reserved.
//

#import "FCPPFaceBeautify.h"

@implementation FCPPFaceBeautify

/**
 人脸美白与磨皮
 中文文档地址：https://console.faceplusplus.com.cn/documents/34878217
 
 @param ImageObj 图片对象
 @param white 美白程度
 @param smooth 磨皮程度
 @param completion 结果回调
 */
-(void)initWithImageObj:(UIImage*)ImageObj withWhite:(int)white withSmoothing:(int)smooth wtihCompletion:(void(^)(id info,NSError *error))completion{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",FACE_BEAUTIFY_WEB_BASE_CN,FACE_BEAUTIFY];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (ImageObj) {
        NSString *baseStr = ImageObj.base64String;
        [param setObject:baseStr forKey:@"image_base64"];
    }
    
    if (white>=0&&white<=100) {
        [param setObject:@(white) forKey:@"whitening"];//默认为100
    }
    if (smooth>=0&&smooth<=100) {
        [param setObject:@(smooth) forKey:@"smoothing"];//默认为100
    }
    [FCPPApi POST:url param:param completion:completion];
    
}


@end
