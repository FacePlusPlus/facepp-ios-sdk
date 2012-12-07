//
//  FaceppRecognition.h
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

typedef enum FaceppRecognitionTrainType {
    FaceppRecognitionTrainTypeAll,
    FaceppRecognitionTrainTypeSearch,
    FaceppRecognitionTrainTypeRecognize
} FaceppRecognitionTrainType;

@interface FaceppRecognition : NSObject

-(FaceppResult*) compareWithFaceId1:(NSString*)id1 andId2:(NSString*)id2;

-(FaceppResult*) recognizeWithGroupId:(NSString*)groupId orGroupName:(NSString*)name andURL:(NSString*)url orImageData:(NSData*)data orKeyFaceId:(NSArray*)keyFaceId;

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andGroupId:(NSString*)groupId orGroupName:(NSString*)groupName;
-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andCount:(NSNumber*)count;

/*!
 *  @brief Train the group synchronously, we will check whether training session is completed every @c refreshDuration seconds automatically
 *  
 *  @note @c refreshDurations's recommended configuration is 1~5s, mininum 1s. If @c timeout = 0, we will waiting until training completed.
 */
-(FaceppResult*) trainSynchronouslyWithGroupId:(NSString*) groupId orGroupName:(NSString*)groupName andType:(FaceppRecognitionTrainType)type refreshDuration:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout;

/*!
 *  @brief Train the group asynchronously, it will return a session_id so that we can check whether training is completed if needed.
 */
-(FaceppResult*) trainAsynchronouslyWithGroupId:(NSString*) groupId orGroupName:(NSString*)groupName andType:(FaceppRecognitionTrainType)type;

-(FaceppResult*) verifyWithFaceId:(NSString*) faceId andPersonId:(NSString*)personId orPersonName:(NSString*)personName;

@end
