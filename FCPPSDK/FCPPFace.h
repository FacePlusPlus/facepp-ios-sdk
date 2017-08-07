//
//  FCPPFaceManager.h
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/6/20.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCPPApi.h"
#import "FCPPFaceSet.h"

@interface FCPPFace : FCPPApi

/**
 *  用来标识检已经测到的人脸
 *  The id of a detected face
 */
@property (copy , nonatomic) NSString  *faceToken;

/**
 *  用faceToken初始化示例,可以用来比对和搜索
 */
- (instancetype)initWithFaceToken:(NSString *)faceToken;

#pragma mark- 人脸比对(1:1)
/**
 将两个人脸进行比对，来判断是否为同一个人以及相似度
 中文文档地址:https://console.faceplusplus.com.cn/documents/4887586
 
 compare two face and get the similarity
 English document:https://console.faceplusplus.com/documents/5679308
 
 @param face    另外一张人脸
 @param completion 结果回调
 */
- (void)compareFaceWithOther:(FCPPFace *)face completion:(void(^)(id info,NSError *error))completion;

#pragma mark- 人脸搜索(1:N)

/**
 从多个人脸中找出最像似的1个或多个(最多5个)
 中文文档:https://console.faceplusplus.com.cn/documents/4888381
 
 search the most similar face in the faceSet, return 5 tokens at most.
 English document:https://console.faceplusplus.com/documents/5681455
 
 @param faceSet faceSet
 @param returnCount 返回的数量,范围是1~5
 @param completion 结果回调
 */
- (void)searchFromFaceSet:(FCPPFaceSet *)faceSet returnCount:(int)returnCount completion:(void(^)(id info,NSError *error))completion;

#pragma mark- 其他
/**
 根据token获取人脸的详细信息
 中文文档地址:https://console.faceplusplus.com.cn/documents/4888383
 
 analyze face by face_token
 English document:https://console.faceplusplus.com/documents/6329465
 
 @param faceTokens faceToken的数组
 @param returnLandmark  是否返回人脸关键点
 @param returnAttributes 需要返回的人脸特征,填写下面的中的一个或多个:gender, age, smiling, headpose, facequality, blur, eyestatus, emotion, ethnicity
 @param completion 结果回调
 */
+ (void)analyzeFaceTokens:(NSArray<NSString *> *)faceTokens return_landmark:(BOOL)returnLandmark attribute:(NSArray<NSString *> *)returnAttributes completion:(void(^)(id info,NSError *error))completion;


/**
 为检测出的某一个人脸添加自定义标识信息，该信息会在Search接口结果中返回，用来确定用户身份.
 中文文档:https://console.faceplusplus.com.cn/documents/4888387
 
 Set user_id for a detected face. user_id can be returned in Search results to determine the identity of user
 English document:https://console.faceplusplus.com/documents/6329500
 
 @param userid 用户自定义的user_id，不超过255个字符，不能包括^@,&=*'"
 @param faceToken 人脸标识face_token
 @param completion 结果回调
 */
+ (void)setUserId:(NSString *)userid toFaceToken:(NSString *)faceToken completion:(void(^)(id info,NSError *error))completion;


/**
 通过传入在Detect API检测出的人脸标识face_token，获取一个人脸的关联信息，包括源图片ID、归属的FaceSet
 中文文档:https://console.faceplusplus.com.cn/documents/4888385
 
 Get related information to a face by passing its face_token which you can get from Detect API. Such as the face related information includes image_id and FaceSet which it belongs to.
 English document:https://console.faceplusplus.com/documents/6329496
 
 @param token      人脸标识face_token
 @param completion 结果回调
 */

+ (void)getDetailWithToken:(NSString *)token completion:(void(^)(id info,NSError *error))completion;
@end
