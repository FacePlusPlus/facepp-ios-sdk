//
//  FaceppGrouping.m
//  FaceppSDK+Demo
//
//  Created by youmu on 13-4-12.
//  Copyright (c) 2013年 Megvii. All rights reserved.
//

#import "FaceppGrouping.h"
#import "FaceppClient.h"

@implementation FaceppGrouping

-(FaceppResult*) groupingWithFacesetId:(NSString*) facesetId orFacesetName:(NSString*)facesetName {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (facesetId != nil) {
        [params addObject:@"faceset_id"];
        [params addObject:facesetId];
    }
    if (facesetName != nil) {
        [params addObject:@"faceset_name"];
        [params addObject:facesetName];
    }
    return [FaceppClient requestWithMethod:@"grouping/grouping" params:params];
}

@end
