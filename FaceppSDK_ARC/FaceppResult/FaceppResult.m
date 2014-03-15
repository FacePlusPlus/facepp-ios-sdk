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

-(id) initWithSuccess: (BOOL) succ withError: (FaceppError*) err {
    if ((self = [super init]) ) {
        success = succ;
        if (err != nil)
            error = err;
    }
    return self;
}

+(id) resultWithSuccess: (BOOL) success withError: (FaceppError*) error {
    return [[FaceppResult alloc] initWithSuccess:success withError:error];
}


@end
