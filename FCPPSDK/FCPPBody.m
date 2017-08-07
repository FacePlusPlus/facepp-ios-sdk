//
//  FCPPBodyManager.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/22.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPBody.h"

@implementation FCPPBody
- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.image = [image fixImageWithMaxSize:CGSizeMake(1080, 1080)];
    }
    return self;
}
- (void)detectBodyWithAttributes:(NSArray<NSString *> *)attributes completion:(void(^)(id info,NSError *error))completion{
    NSString *url = HUMANBODY_DETECT;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *att = [attributes componentsJoinedByString:@","];
    if (att.length) {
        [param setObject:att.copy forKey:@"return_attributes"];
    }
    
    if (self.image) {
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"image_base64"];
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

- (void)segmentBodyCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = HUMANBODY_SEGMENT;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.image) {
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"image_base64"];
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
