//
//  FaceppTrainer.h
//  FaceppSDK+Demo
//
//  Created by youmu on 13-4-12.
//  Copyright (c) 2013 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

typedef enum FaceppTrainType {
    FaceppTrainVerify,
    FaceppTrainSearch,
    FaceppTrainIdentify
} FaceppTrainType;

@interface FaceppTrainer : NSObject

/*!
 *  @brief Train synchronously, we will check whether training session is completed every @c refreshDuration seconds automatically
 *
 *  @note @c refreshDurations's recommended configuration is 1~5s, mininum 1s. If @c timeout = 0, we will waiting until training completed.
 */
-(FaceppResult*) trainSynchronouslyWithId:(NSString*) objId orName:(NSString*)objName andType:(FaceppTrainType)type refreshDuration:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout;

/*!
 *  @brief Train asynchronously, it will return a session_id so that we can check whether training is completed if needed.
 */
-(FaceppResult*) trainAsynchronouslyWithId:(NSString*) objId orName:(NSString*)objName andType:(FaceppTrainType)type;

@end
