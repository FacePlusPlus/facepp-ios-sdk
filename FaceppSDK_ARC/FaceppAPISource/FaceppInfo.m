//
//  FaceppInfo.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppInfo.h"
#import "FaceppClient.h"

@implementation FaceppInfo

-(FaceppResult*) getApp {
    return [FaceppClient requestWithParameters:@"info/get_app" :nil];
}

-(FaceppResult*) getFaceWithFaceId:(NSString*)faceId {
    return [FaceppClient requestWithParameters:@"info/get_face" :[NSArray arrayWithObjects:@"face_id", faceId, nil]];
}

-(FaceppResult*) getGroupList {
    return [FaceppClient requestWithParameters:@"info/get_group_list" :nil];
}

-(FaceppResult*) getImageWithImgId:(NSString*)imageId {
    return [FaceppClient requestWithParameters:@"info/get_image" :[NSArray arrayWithObjects:@"img_id", imageId, nil]];
}

-(FaceppResult*) getPersonList {
    return [FaceppClient requestWithParameters:@"info/get_person_list" :nil];
}

-(FaceppResult*) getFacesetList {
    return [FaceppClient requestWithParameters:@"info/get_faceset_list" :nil];
}

-(FaceppResult*) getQuota {
    return [FaceppClient requestWithParameters:@"info/get_quota" :nil];
}

-(FaceppResult*) getSessionWithSessionId:(NSString*)sessionId {
    return [FaceppClient requestWithParameters:@"info/get_session" :[NSArray arrayWithObjects:@"session_id", sessionId, nil]];
}

@end
