//
//  FCPPFaceManager.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/20.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPFace.h"
#import "FCPPConfig.h"

@implementation FCPPFace

- (instancetype)initWithFaceToken:(NSString *)faceToken{
    if (self = [super init]) {
        self.faceToken = faceToken;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.image = [image fixImageWithMaxSize:CGSizeMake(4096, 4096)];
    }
    return self;
}


- (void)compareFaceWithOther:(FCPPFace *)face completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",FACE_WEB_BASE,FACE_COMPARE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.faceToken){
        [param setObject:self.faceToken forKey:@"face_token1"];
    }else if (self.image){
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"image_base64_1"];
    }else if (self.imageUrl) {
        [param setObject:self.imageUrl forKey:@"image_url1"];
    }
    
    if (face.faceToken){
        [param setObject:face.faceToken forKey:@"face_token2"];
    }else if (face.image){
        NSString *baseStr = face.image.base64String;
        [param setObject:baseStr forKey:@"image_base64_2"];
    }else if (face.imageUrl) {
        [param setObject:face.imageUrl forKey:@"image_url2"];
    }

    [FCPPApi POST:url param:param completion:completion];
}

- (void)searchFromFaceSet:(FCPPFaceSet *)faceSet returnCount:(int)returnCount completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@",FACE_WEB_BASE,FACE_SEARCH];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.faceToken){
        [param setObject:self.faceToken forKey:@"face_token"];
    }else if (self.image){
        NSString *baseStr = self.image.base64String;
        [param setObject:baseStr forKey:@"image_base64"];
    }else if (self.imageUrl) {
        [param setObject:self.imageUrl forKey:@"image_url"];
    }
    
    if (returnCount > 0 && returnCount < 6) {
        [param setObject:@(returnCount) forKey:@"return_result_count"];
    }
    
    if (faceSet.faceset_token) {
        [param setObject:faceSet.faceset_token forKey:@"faceset_token"];
    }else if (faceSet.outer_id){
        [param setObject:faceSet.outer_id forKey:@"outer_id"];
    }
    
    [FCPPApi POST:url param:param completion:completion];
}

+ (void)analyzeFaceTokens:(NSArray<NSString *> *)tokens return_landmark:(BOOL)return_landmark attribute:(NSArray<NSString *> *)attributes completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACETOEKN,FACETOEKN_ANALYZE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *tokenStr = [tokens componentsJoinedByString:@","];
    
    if (tokenStr.length) {
        [param setObject:tokenStr forKey:@"face_tokens"];
    }else{
        NSLog(@"faceTokens can not be nil");
    }
    
    NSNumber *landmark = return_landmark ? @(1) : @(0);
    [param setObject:landmark forKey:@"return_landmark"];
    
    NSString *att = [attributes componentsJoinedByString:@","];
    if (att.length) {
        [param setObject:att.copy forKey:@"return_attributes"];
    }

    [FCPPApi POST:url param:param completion:completion];
}

+ (void)setUserId:(NSString *)userid toFaceToken:(NSString *)token completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACETOEKN,FACETOEKN_SET_USERID];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (userid.length == 0 || token.length == 0) {
        NSLog(@"userid and token can not be nil");
    }
    
    [param setObject:userid forKey:@"user_id"];
    [param setObject:token forKey:@"face_token"];
    
    [FCPPApi POST:url param:param completion:completion];
}

+ (void)getDetailWithToken:(NSString *)token completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACETOEKN,FACETOEKN_GET_DETAIL];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (token.length == 0) {
        NSLog(@"token can not be nil");
    }else{
        [param setObject:token forKey:@"face_token"];
    }
    
    [FCPPApi POST:url param:param completion:completion];
}
@end
