//
//  FaceppAPI.m
//  ImageCapture
//
//  Created by youmu on 12-11-28.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppAPI.h"
#import "FaceppClient.h"

static FaceppDetection* detectionSharedInstance = nil;
static FaceppRecognition* recognitionSharedInstance = nil;
static FaceppPerson* personSharedInstance = nil;
static FaceppGroup* groupSharedInstance = nil;
static FaceppInfo* infoSharedInstance = nil;
static FaceppTrainer* trainSharedInstance = nil;
static FaceppFaceset* facesetSharedInstance = nil;
static FaceppGrouping* groupingSharedInstance = nil;

@implementation FaceppAPI

+(void)setDebugMode:(BOOL) on {
    [FaceppClient setDebugMode:on];
}

+(void)initWithApiKey:(NSString*) apiKey andApiSecret:(NSString*) apiSecret andRegion:(APIServerRegion)region{
    [FaceppClient initializeWithApiKey:apiKey apiSecret:apiSecret region:region];
}

+(FaceppDetection*) detection {
    if (detectionSharedInstance == nil)
        detectionSharedInstance = [[FaceppDetection alloc] init];
    return detectionSharedInstance;
}

+(FaceppRecognition*) recognition {
    if (recognitionSharedInstance == nil)
        recognitionSharedInstance = [[FaceppRecognition alloc] init];
    return recognitionSharedInstance;
}

+(FaceppPerson*) person {
    if (personSharedInstance == nil)
        personSharedInstance = [[FaceppPerson alloc] init];
    return personSharedInstance;
}

+(FaceppGroup*) group {
    if (groupSharedInstance == nil)
        groupSharedInstance = [[FaceppGroup alloc] init];
    return groupSharedInstance;
}

+(FaceppFaceset*) faceset {
    if (facesetSharedInstance == nil)
        facesetSharedInstance = [[FaceppFaceset alloc] init];
    return facesetSharedInstance;
}

+(FaceppTrainer*) train {
    if (trainSharedInstance == nil)
        trainSharedInstance = [[FaceppTrainer alloc] init];
    return trainSharedInstance;
}

+(FaceppInfo*) info {
    if (infoSharedInstance == nil)
        infoSharedInstance = [[FaceppInfo alloc] init];
    return infoSharedInstance;
}

+(FaceppGrouping*) grouping {
    if (groupingSharedInstance == nil)
        groupingSharedInstance = [[FaceppGrouping alloc] init];
    return groupingSharedInstance;
}

@end
