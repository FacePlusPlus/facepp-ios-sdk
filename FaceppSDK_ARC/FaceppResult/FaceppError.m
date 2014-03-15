//
//  FaceppError.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppError.h"

@implementation FaceppError

@synthesize httpStatusCode;
@synthesize errorCode;
@synthesize message;

-(id) initWithErrorMsg:(NSString*) msg andHttpStatusCode:(int)httpCode andErrorCode:(int) code {
    if ((self = [super init]) ) {
        self.httpStatusCode = httpStatusCode;
        self.errorCode = code;
        if (msg != nil)
            self.message = [[NSString alloc] initWithString: msg];
    }
    return self;
}

+(id) errorWithErrorMsg:(NSString*) msg andHttpStatusCode:(int)httpCode andErrorCode:(int) code {
    return [[FaceppError alloc] initWithErrorMsg:msg andHttpStatusCode:httpCode andErrorCode:code];
}

+(id) checkErrorFromJSONDictionary:(NSDictionary*) dict andHttpStatusCode:(int)httpCode{
    if (dict[@"error_code"] != nil)
        return [FaceppError errorWithErrorMsg:dict[@"error"] andHttpStatusCode:httpCode andErrorCode:[dict[@"error_code"] intValue]];
    
    return nil;
}


@end
