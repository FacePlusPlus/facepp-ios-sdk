//
//  FCPPFaceDetector.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/18.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPFaceDetect.h"

@implementation FCPPFaceDetect

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.image = [image fixImageWithMaxSize:CGSizeMake(4096, 4096)];
    }
    return self;
}

- (void)detectFaceWithReturnLandmark:(BOOL)return_landmark attributes:(NSArray<NSString *> *)attributes completion:(void(^)(id info,NSError *error))completion{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",FACE_WEB_BASE,FACE_DETECT];
    NSNumber *landmark = return_landmark ? @(1) : @(0);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:landmark forKey:@"return_landmark"];
    
    NSString *att = [attributes componentsJoinedByString:@","];
    if (att.length) {
        [param setObject:att.copy forKey:@"return_attributes"];
    }
    
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
    }else{
        NSLog(@"please set a image object or url ");
    }
    [FCPPApi POST:url param:param completion:completion];
}
@end
