//
//  FaceppTrainer.m
//  FaceppSDK+Demo
//
//  Created by youmu on 13-4-12.
//  Copyright (c) 2013年 Megvii. All rights reserved.
//

#import "FaceppTrainer.h"
#import "FaceppClient.h"

@implementation FaceppTrainer

-(FaceppResult*) trainAsynchronouslyWithId:(NSString *)objId orName:(NSString *)objName andType:(FaceppTrainType)type {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    NSString *typeStr = nil;
    NSString *prefix = nil;
    switch (type) {
        case FaceppTrainVerify:
            typeStr = @"verify";
            prefix = @"person";
            break;
        case FaceppTrainIdentify:
            typeStr = @"identify";
            prefix = @"group";
            break;
        case FaceppTrainSearch:
            typeStr = @"search";
            prefix = @"faceset";
            break;
        default:
            break;
    }
    if (objId != nil) {
        [params addObject:[NSString stringWithFormat:@"%@_id", prefix]];
        [params addObject:objId];
    }
    if (objName != nil) {
        [params addObject:[NSString stringWithFormat:@"%@_name", prefix]];
        [params addObject:objName];
    }
    return [FaceppClient requestWithMethod:[NSString stringWithFormat:@"train/%@", typeStr] params:params];
}

-(FaceppResult*) trainSynchronouslyWithId:(NSString *)objId orName:(NSString *)objName andType:(FaceppTrainType)type refreshDuration:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    NSString *typeStr = nil;
    NSString *prefix = nil;
    switch (type) {
        case FaceppTrainVerify:
            typeStr = @"verify";
            prefix = @"person";
            break;
        case FaceppTrainIdentify:
            typeStr = @"identify";
            prefix = @"group";
            break;
        case FaceppTrainSearch:
            typeStr = @"search";
            prefix = @"faceset";
            break;
        default:
            break;
    }
    if (objId != nil) {
        [params addObject:[NSString stringWithFormat:@"%@_id", prefix]];
        [params addObject:objId];
    }
    if (objName != nil) {
        [params addObject:[NSString stringWithFormat:@"%@_name", prefix]];
        [params addObject:objName];
    }

    FaceppResult *sessionResult = [FaceppClient requestWithMethod:[NSString stringWithFormat:@"train/%@", typeStr] params:params];
    if (![sessionResult success])
        return sessionResult;
    
    NSString *sessionId = [sessionResult content][@"session_id"];
    bool flag = false;
    NSDate *startTime = [NSDate date];
    interval = MAX(interval, 1);
    if (timeout < 1e-6)
        timeout = MAXFLOAT;
    
    while ((!flag) && ([[NSDate date] timeIntervalSinceDate:startTime] < timeout)) {
        FaceppResult *result = [[FaceppAPI info] getSessionWithSessionId:sessionId];
        if ([result success]) {
            if ([[result content][@"result"][@"success"] boolValue] == true)
                return result;
        } else {
            return result;
        }
        [NSThread sleepForTimeInterval:interval];
    }
    return [FaceppResult resultWithSuccess:false withError:[FaceppError errorWithErrorMsg:@"trainSynchronously method timeout" andHttpStatusCode:0 andErrorCode:0]];
}

@end
