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

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*) data {
    return [self detectWithURL:url orImageData:data mode:FaceppDetectionModeNormal];
}

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode {
    return [self detectWithURL:url orImageData:data mode:mode attribute:FaceppDetectionAttributeAll];
}

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute {
    return [self detectWithURL:url orImageData:data mode:mode attribute:attribute tag:nil];
}

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag {
    return [self detectWithURL:url orImageData:data mode:mode attribute:attribute tag:nil async:NO];
}

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag async:(BOOL)async {
    return [self detectWithURL:url orImageData:data mode:mode attribute:attribute tag:tag async:async others:nil];
}

-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag async:(BOOL)async others:(NSArray*) others {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:20];
    if (url != nil) {
        [params addObject:@"url"];
        [params addObject:url];
    }
    if (mode != FaceppDetectionModeDefault) {
        [params addObject:@"mode"];
        if (mode == FaceppDetectionModeNormal)
            [params addObject:@"normal"];
        else
            [params addObject:@"oneface"];
    }
    NSMutableString *attr = [NSMutableString string];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributeAge andAttributeName:@"age"];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributeRace andAttributeName:@"race"];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributeGender andAttributeName:@"gender"];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributeSmiling andAttributeName:@"smiling"];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributePose andAttributeName:@"pose"];
    attr = [self appendAttributeString:attr andParam:attribute andCheckItem:FaceppDetectionAttributeGlass andAttributeName:@"glass"];
    if (attr.length <= 0)
        attr = [NSMutableString stringWithString:@"none"];
    [params addObject:@"attribute"];
    [params addObject:attr];
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    if (async) {
        [params addObject:@"async"];
        [params addObject:@"true"];
    }
    if (others != nil) {
        size_t count = 2;
        while (count <= [others count]) {
            if (([[[others objectAtIndex:count-2] class] isSubclassOfClass:[NSString class]]) &&
                ([[[others objectAtIndex:count-1] class] isSubclassOfClass:[NSString class]])) {
                [params addObject:[others objectAtIndex:count-2]];
                [params addObject:[others objectAtIndex:count-1]];
            }
            count += 2;
        }
    }
    
    // request
    if (data != NULL)
        return [FaceppClient requestWithMethod:@"detection/detect" image:data params:params];
    else
        return [FaceppClient requestWithMethod:@"detection/detect" params:params];
}

-(NSMutableString*) appendAttributeString: (NSMutableString*)orig andParam: (FaceppDetectionAttribute)param andCheckItem: (FaceppDetectionAttribute)checkItem andAttributeName: (NSString*)attrName {
    if ((param & checkItem) > 0) {
        if ([orig length] > 0)
            [orig appendFormat:@",%@", attrName];
        else
            [orig appendString:attrName];
    }
    return orig;
}

-(FaceppResult*) landmarkWithFaceId: (NSString*) face andType:(FaceppLandmarkType) type {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    [params addObject: @"face_id"];
    [params addObject: face];
    if (type == FaceppLandmark25P) {
        [params addObject: @"type"];
        [params addObject: @"25p"];
    }
    return [FaceppClient requestWithMethod:@"detection/landmark" params:params];
}

@end
