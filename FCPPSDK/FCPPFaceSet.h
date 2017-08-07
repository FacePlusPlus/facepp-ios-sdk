//
//  FCPPFaceSetManager.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/21.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCPPApi.h"

@interface FCPPFaceSet : NSObject

/**
 *  faceSet的唯一标识,由系统返回
 *  The id of a faceSet which returned by api.
 */
@property (copy , nonatomic) NSString *faceset_token;

/**
 *  用户提供的FaceSet唯一标识
 *  User-defined id of Faceset
 */
@property (copy , nonatomic) NSString *outer_id;

- (instancetype)initWithFaceSetToken:(NSString *)faceSetToken;

- (instancetype)initWithOuterId:(NSString *)outerId;

/**
 创建一个人脸的集合FaceSet，用于存储人脸标识face_token,用于后续的搜索功能.
 中文文档: https://console.faceplusplus.com.cn/documents/4888391
 
 Create a face collection to store face_token. The collection will be used in the search operation.
 English document:https://console.faceplusplus.com/documents/6329329
 
 @param displayName 人脸集合的名字，256个字符，不能包括字符^@,&=*'"
 @param outerId 自定义唯一的FaceSet标识，可以用来管理FaceSet对象。最长255个字符，不能包括字符^@,&=*'"
 @param tags FaceSet自定义标签组成的字符串，用来对FaceSet分组。最长255个字符，多个tag用逗号分隔，每个tag不能包括字符^@,&=*'"
 @param tokens 人脸标识face_token，可以是一个或者多个，用逗号分隔。最多不超过5个face_token,会被直接加入faceset中
 @param userData 自定义用户信息，不大于16KB，不能包括字符^@,&=*'"
 @param forceMerge 在传入outer_id的情况下，如果outer_id已经存在，是否将face_token加入已经存在的FaceSet中,0：不将face_tokens加入已存在的FaceSet中，直接返回FACESET_EXIST错误
 @param completion 回调
 */
+ (void)createFaceSetWithDisplayName:(NSString *)displayName outerId:(NSString *)outerId tgas:(NSArray<NSString *> *)tags faceTokens:(NSArray *)tokens userData:(NSString *)userData forceMerge:(BOOL)forceMerge completion:(void(^)(id info,NSError *error))completion;


/**
 获取指定tag的faceset,如果为空,则返回所有faceset
 中文文档: https://console.faceplusplus.com.cn/documents/4888397
 
 get the faceset by tags,if tags == nil, return all the facesets
 英文文档: https://console.faceplusplus.com/documents/6329430
 
 @param tags faceset的tag
 @param completion 结果回调
 */
+ (void)getFaceSetsWithTags:(NSArray<NSString *> *)tags completion:(void(^)(id info,NSError *error))completion;

/**
 添加多个faceToken到faceset中
 中文文档: https://console.faceplusplus.com.cn/documents/4888389
 
 add several faceTokens to the faceset
 English document: https://console.faceplusplus.com/documents/6329371
 
 @param tokens faceTokens
 @param completion 结果回调
 */
- (void)addFaceTokens:(NSArray<NSString *> *)tokens completion:(void(^)(id info,NSError *error))completion;


/**
 从faceset中移除faceTokens
 中文文档: https://console.faceplusplus.com.cn/documents/4888399
 
 remove faceTokens from faceset
 English document: https://console.faceplusplus.com/documents/6329376
 
 @param tokens faceTokens
 @param completion 结果回调
 */
- (void)removeFaceToken:(NSArray<NSString *> *)tokens completion:(void(^)(id info,NSError *error))completion;


/**
 更新一个人脸集合的属性
 中文文档: https://console.faceplusplus.com.cn/documents/4888401
 
 update a faceset with some attributes such as new_outer_id,display_name,user_data,tags
 English document: https://console.faceplusplus.com/documents/6329383
 
 @param dic 需要更新的属性字典,key为 @"new_outer_id",@"display_name",@"user_data",tags其中的一个或者多个
 @param completion 结果回调
 */
- (void)updateFaceSetWithDic:(NSDictionary *)dic completion:(void(^)(id info,NSError *error))completion;


/**
 获取一个FaceSet的所有信息
 中文文档: https://console.faceplusplus.com.cn/documents/4888395
 
 Get details about a FaceSet.
 English document: https://console.faceplusplus.com/documents/6329388

 @param completion 结果回调
 */
- (void)getDetailCompletion:(void(^)(id info,NSError *error))completion;


/**
 删除一个人脸集合
 中文文档: https://console.faceplusplus.com.cn/documents/4888393
 
 delete a faceset
 English document: https://console.faceplusplus.com/documents/6329394
 
 @param checkEmpty 删除时是否检查FaceSet中是否存在face_token，默认值为1,FaceSet中存在face_token则不能删除.
 @param completion 结果回调
 */
- (void)deleteFaceSetCheckEmpty:(BOOL)checkEmpty completion:(void(^)(id info,NSError *error))completion;


@end
