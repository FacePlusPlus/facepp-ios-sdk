//
//  FCPPFaceSetManager.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/21.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCPPFaceSet.h"

@implementation FCPPFaceSet

- (instancetype)initWithFaceSetToken:(NSString *)faceSetToken{
    if (self = [super init]) {
        self.faceset_token = faceSetToken;
    }
    return self;
}

- (instancetype)initWithOuterId:(NSString *)outerId{
    if (self = [super init]) {
        self.outer_id = outerId;
    }
    return self;
}

+ (void)createFaceSetWithDisplayName:(NSString *)displayName outerId:(NSString *)outerId tgas:(NSArray<NSString *> *)tags faceTokens:(NSArray *)tokens userData:(NSString *)userData forceMerge:(BOOL)forceMerge completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_CREATE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (displayName.length) {
        param[@"display_name"]  = displayName;
    }
    if (outerId.length) {
        param[@"outer_id"]  = outerId;
    }
    if (userData.length) {
        param[@"user_data"]  = userData;
    }
    
    if (tags.count) {
        NSString *tagStr = [tags componentsJoinedByString:@","];
        param[@"tags"] = tagStr;
    }
    
    if (tokens) {
        NSString *tokenStr = [tokens componentsJoinedByString:@","];
        param[@"face_tokens"] = tokenStr;
    }
    NSNumber *force_merge = forceMerge ? @(1) : @(0);
    [param setObject:force_merge forKey:@"force_merge"];
    [FCPPApi POST:url param:param completion:completion];
}

- (void)addFaceTokens:(NSArray<NSString *> *)tokens completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_ADDFACE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (tokens.count) {
        NSString *tokenStr = [tokens componentsJoinedByString:@","];
        param[@"face_tokens"] = tokenStr;
    }
    
    if (self.faceset_token) {
        param[@"faceset_token"] = self.faceset_token;
    }else if(self.outer_id){
        param[@"outer_id"] = self.outer_id;
    }
    
    [FCPPApi POST:url param:param completion:completion];
}

- (void)removeFaceToken:(NSArray<NSString *> *)tokens completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_REMOVE_FACE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (tokens.count) {
        NSString *tokenStr = [tokens componentsJoinedByString:@","];
        param[@"face_tokens"] = tokenStr;
    }else{
        NSLog(@"token can not nil");
    }
    
    if (self.faceset_token) {
        param[@"faceset_token"] = self.faceset_token;
    }else if(self.outer_id){
        param[@"outer_id"] = self.outer_id;
    }
    
    [FCPPApi POST:url param:param completion:completion];
}

- (void)updateFaceSetWithDic:(NSDictionary *)dic completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_UPDATE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (dic.allKeys.count) {
        [param addEntriesFromDictionary:dic];
    }
    
    if (self.faceset_token) {
        param[@"faceset_token"] = self.faceset_token;
    }else if(self.outer_id){
        param[@"outer_id"] = self.outer_id;
    }
    
    [FCPPApi POST:url param:param completion:completion];
}

- (void)deleteFaceSetCheckEmpty:(BOOL)checkEmpty completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_DELETE];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSNumber *check_empty = checkEmpty ? @(1) : @(0);
    [param setObject:check_empty forKey:@"check_empty"];
   
    if (self.faceset_token) {
        param[@"faceset_token"] = self.faceset_token;
    }else if(self.outer_id){
        param[@"outer_id"] = self.outer_id;
    }
    
    [FCPPApi POST:url param:param completion:completion];
}
- (void)getDetailCompletion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_GET_DETAIL];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.faceset_token) {
        param[@"faceset_token"] = self.faceset_token;
    }else if(self.outer_id){
        param[@"outer_id"] = self.outer_id;
    }
    
    [FCPPApi POST:url param:param completion:completion];
}
+ (void)getFaceSetsWithTags:(NSArray<NSString *> *)tags completion:(void(^)(id info,NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",FACE_WEB_BASE,FACESET,FACESET_GET_FACESETS];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *tagStr = [tags componentsJoinedByString:@","];
    if (tagStr.length) {
        [param setObject:tagStr forKey:@"tags"];
    }
    
    [FCPPApi POST:url param:param completion:completion];
}
@end
