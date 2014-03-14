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

-(FaceppResult*) compareWithFaceId1:(NSString*)id1 andId2:(NSString*)id2 async:(BOOL)async{
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"face_id1", id1, @"face_id2", id2, nil];
    if (async) {
        [params addObject:@"async"];
        [params addObject:@"true"];
    }
    return [FaceppClient requestWithMethod:@"recognition/compare" params:params];
}

-(FaceppResult*) identifyWithGroupId:(NSString*)groupId orGroupName:(NSString*)name andURL:(NSString*)url orImageData:(NSData*)data orKeyFaceId:(NSArray*)keyFaceId async:(BOOL)async {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:16];
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
    if (async) {
        [params addObject:@"async"];
        [params addObject:@"true"];
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
        return [FaceppClient requestWithMethod:@"recognition/identify" image:data params:params];
    else
        return [FaceppClient requestWithMethod:@"recognition/identify" params:params];
}

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andFacesetId:(NSString*)facesetId orFacesetName:(NSString*)facesetName {
    return [self searchWithKeyFaceId:keyFaceId andFacesetId:facesetId orFacesetName:facesetName andCount:nil async:NO];
}

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andFacesetId:(NSString*)facesetId orFacesetName:(NSString*)facesetName andCount:(NSNumber*)count async:(BOOL)async{
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:16];
    if (keyFaceId != nil) {
        [params addObject:@"key_face_id"];
        [params addObject:keyFaceId];
    }
    if (facesetId != nil) {
        [params addObject:@"faceset_id"];
        [params addObject:facesetId];
    }
    if (facesetName != nil) {
        [params addObject:@"faceset_name"];
        [params addObject:facesetName];
    }
    if (count != nil) {
        [params addObject:@"count"];
        [params addObject:count];
    }
    if (async) {
        [params addObject:@"async"];
        [params addObject:@"true"];
    }

    return [FaceppClient requestWithMethod:@"recognition/search" params:params];
}

-(FaceppResult*) verifyWithFaceId:(NSString*) faceId andPersonId:(NSString*)personId orPersonName:(NSString*)personName async:(BOOL)async{
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"face_id", faceId, nil];
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    if (async) {
        [params addObject:@"async"];
        [params addObject:@"true"];
    }

    return [FaceppClient requestWithMethod:@"recognition/verify" params:params];
}

@end
