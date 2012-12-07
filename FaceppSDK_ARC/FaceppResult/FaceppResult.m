//
//  FaceppResult.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppResult.h"

@implementation FaceppResult

@synthesize error;
@synthesize success;
@synthesize content;

-(id) initWithSuccess: (BOOL) succ: (FaceppError*) err {
    if ((self = [super init]) ) {
        success = succ;
        error = err;
    }
    return self;
}

+(id) resultWithSuccess: (BOOL) success: (FaceppError*) error {
    return [[FaceppResult alloc] initWithSuccess:success :error];
}

@end
