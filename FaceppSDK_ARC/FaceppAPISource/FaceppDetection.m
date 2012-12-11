//
//  FaceppDetection.m
//  ImageCapture
//
//  Created by youmu on 12-11-26.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppDetection.h"
#import "FaceppClient.h"

@implementation FaceppDetection

-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*) data {
    return [self detectWithURL:url imageData:data mode:FaceppDetectionModeNormal];
}

-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode {
    return [self detectWithURL:url imageData:data mode:mode attribute:FaceppDetectionAttributeAll];
}

-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute {
    return [self detectWithURL:url imageData:data mode:mode attribute:attribute tag:nil];
}

-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (url != nil) {
        [params addObject:@"url"];
        [params addObject:url];
    }
    if (mode != FaceppDetectionModeNormal) {
        [params addObject:@"mode"];
        [params addObject:@"oneface"];
    }
    if (attribute != FaceppDetectionAttributeAll) {
        [params addObject:@"attribute"];
        [params addObject:@"none"];
    }
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    
    // request
    if (data != NULL)
        return [FaceppClient requestWithImage:@"detection/detect" :data :params];
    else
        return [FaceppClient requestWithParameters:@"detection/detect" :params];
}

@end
