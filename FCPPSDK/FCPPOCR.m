//
//  FCPPOCRManager.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/22.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPOCR.h"
#import "FCPPConfig.h"

@implementation FCPPOCR
- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.image = [image fixImageWithMaxSize:CGSizeMake(4096, 4096)];
    }
    return self;
}
- (void)ocrIDCardCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",OCR_CN,OCR_CARD];
    [self POST:url completion:completion];
}

- (void)ocrDriverLicenseCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",OCR_CN,OCR_DRIVER_LICENSE];
    [self POST:url completion:completion];
}

- (void)ocrVehicleLicenseCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",OCR_CN,OCR_VEHICLE_LICENSE];
    [self POST:url completion:completion];
}

- (void)ocrTextCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",IMAGE_CN,IMAGE_Text];
    [self POST:url completion:completion];
}

- (void)ocrTextBetaCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",IMAGE_CN,IMAGE_Text_Beta];
    [self POST:url completion:completion];
}

- (void)detectSceneAndObjectCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",IMAGE_CN,IMAGE_Object];
    [self POST:url completion:completion];
}

- (void)POST:(NSString *)url completion:(void(^)(id info,NSError *error))completion{
    if (!isChina) {
        NSLog(@"Error-->This method is only for China");
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.image) {
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"image_base64"];
//        [param setObject:self.image.imageData forKey:@"image_file"];
    }else if (self.imageUrl){
        if ([self.imageUrl hasPrefix:@"http"]) {
            [param setObject:self.imageUrl forKey:@"image_url"];
        }else{
            NSLog(@"please input a vaild url");
        }
    }
    
    [FCPPApi POST:url param:param completion:completion];
}
@end
