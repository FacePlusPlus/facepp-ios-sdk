//
//  FaceppRecognition.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppRecognition.h"
#import "FaceppClient.h"
#import "FaceppAPI.h"

@implementation FaceppRecognition

-(FaceppResult*) compareWithFaceId1:(NSString*)id1 andId2:(NSString*)id2 {
    return [FaceppClient requestWithParameters:@"recognition/compare" :[NSArray arrayWithObjects:@"face_id1", id1, @"face_id2", id2, nil]];
}

-(FaceppResult*) recognizeWithGroupId:(NSString*)groupId orGroupName:(NSString*)name andURL:(NSString*)url orImageData:(NSData*)data orKeyFaceId:(NSArray*)keyFaceId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (name != nil) {
        [params addObject:@"group_name"];
        [params addObject:name];
    }
    if (url != nil) {
        [params addObject:@"url"];
        [params addObject:url];
    }
    if ((keyFaceId != nil) && ([keyFaceId count]>0)) {
        [params addObject:@"key_face_id"];
        NSMutableString *faces = [NSMutableString stringWithString:[keyFaceId objectAtIndex:0]];
        for (int i=1; i<[keyFaceId count]; i++)
            [faces appendFormat:@",%@", [keyFaceId objectAtIndex:i]];
        [params addObject:faces];
    }
    
    // request
    if (data != NULL)
        return [FaceppClient requestWithImage:@"recognition/recognize" :data :params];
    else
        return [FaceppClient requestWithParameters:@"recognition/recognize" :params];
}

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andGroupId:(NSString*)groupId orGroupName:(NSString*)groupName {
    return [self searchWithKeyFaceId:keyFaceId andGroupId:groupId orGroupName:groupName andCount:nil];
}

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andCount:(NSNumber*)count {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (keyFaceId != nil) {
        [params addObject:@"key_face_id"];
        [params addObject:keyFaceId];
    }
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    if (count != nil) {
        [params addObject:@"count"];
        [params addObject:count];
    }
    return [FaceppClient requestWithParameters:@"recognition/search" :params];
}

-(FaceppResult*) trainAsynchronouslyWithGroupId:(NSString*) groupId orGroupName:(NSString*)groupName andType:(FaceppRecognitionTrainType)type {
    NSString *typeStr = nil;
    switch (type) {
        case FaceppRecognitionTrainTypeAll:
            typeStr = @"all";
            break;
        case FaceppRecognitionTrainTypeRecognize:
            typeStr = @"recognize";
            break;
        case FaceppRecognitionTrainTypeSearch:
            typeStr = @"search";
            break;
        default:
            typeStr = @"unknown";
            break;
    }
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"type", typeStr, nil];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    return [FaceppClient requestWithParameters:@"recognition/train" :params];
}

-(FaceppResult*) trainSynchronouslyWithGroupId:(NSString*) groupId orGroupName:(NSString*)groupName andType:(FaceppRecognitionTrainType)type refreshDuration:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout{
    NSString *typeStr = nil;
    switch (type) {
        case FaceppRecognitionTrainTypeAll:
            typeStr = @"all";
            break;
        case FaceppRecognitionTrainTypeRecognize:
            typeStr = @"recognize";
            break;
        case FaceppRecognitionTrainTypeSearch:
            typeStr = @"search";
            break;
        default:
            typeStr = @"unknown";
            break;
    }
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"type", typeStr, nil];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    
    FaceppResult *sessionResult = [FaceppClient requestWithParameters:@"recognition/train" :params];
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
    return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:@"trainSynchronously method timeout" andHttpStatusCode:0 andErrorCode:0]];
}

-(FaceppResult*) verifyWithFaceId:(NSString*) faceId andPersonId:(NSString*)personId orPersonName:(NSString*)personName {
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"face_id", faceId, nil];
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    return [FaceppClient requestWithParameters:@"recognition/verify" :params];
}

@end
