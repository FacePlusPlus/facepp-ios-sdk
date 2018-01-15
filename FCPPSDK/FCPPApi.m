//
//  FCPPApi.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/16.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPApi.h"
#import "AFNetworking.h"

@interface FCPPApi()

@end

@implementation FCPPApi

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        //留给子类重写
    }
    return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl{
    if (self = [super init]) {
        self.imageUrl = imageUrl;
    }
    return self;
}

+ (void)POST:(NSString *)url param:(NSDictionary *)dic completion:(void(^)(id info,NSError *error))completion{

    if (kApiKey.length == 0 || kApiSecret.length == 0) {
        NSDictionary *userInfo = @{@"reason" : @"please config a apikey and secret"};
        NSLog(@"%@",userInfo);
        if (completion) {
            NSError *error = [NSError errorWithDomain:url code:401 userInfo:userInfo];
            completion(nil,error);
            return;
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    [param setValue:kApiKey forKey:@"api_key"];
    [param setValue:kApiSecret forKey:@"api_secret"];

    //fileData抽取出来
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionary];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key hasPrefix:@"image_file"]) {
            [param removeObjectForKey:key];
            if ([obj isKindOfClass:[NSData class]]) {
                [fileDic setObject:obj forKey:key];
            }
        }
    }];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [fileDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:key fileName:key mimeType:@"image/jpeg"];
        }];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if(error == nil){
                          if (completion) {
                              completion(responseObject,nil);
                          }
                      }else{
                          if (completion) {
                              NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                              if (errorData) {
                                  NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                                  NSLog(@"%@",errorStr);
                              }else{
                                  NSLog(@"error: %@",error);
                              }
                              completion(nil,error);
                          }
                      }
                  }];
    
    [uploadTask resume];
    

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (completion) {
//            completion(responseObject,nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (completion) {
//            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//            if (errorData) {
//                NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
//                NSLog(@"%@",errorStr);
//            }else{
//                NSLog(@"%@",error);
//            }
//            completion(nil,error);
//        }
//    }];
}
@end
