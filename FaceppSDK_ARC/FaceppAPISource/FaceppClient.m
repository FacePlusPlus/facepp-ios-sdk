//
//  FacePPClient.m
//  ImageCapture
//
//  Created by youmu on 12-10-25.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppClient.h"

static bool initilized = false;
static NSString *NOT_INIT_ERROR_MSG = @"FacePlusPlus client has not been initialized yet, please use [FaceppAPI initWithApiKey: andApiSecret] first";
static NSString *FACEPP_API_KEY = @"";
static NSString *FACEPP_API_SECRET = @"";
static bool debugMode = false;

#define SERVER_ADDRESS @"http://api.faceplusplus.com/"

@implementation FaceppClient

+(void) setDebugMode:(BOOL) on {
    debugMode = on;
}

+(void) initializeWithApiKey: (NSString*)apiKey apiSecret:(NSString*) apiSecret {
    initilized = true;
    FACEPP_API_KEY = [NSString stringWithFormat:@"%@", apiKey];
    FACEPP_API_SECRET = [NSString stringWithFormat:@"%@", apiSecret];
}

+(NSString *)generateBoundaryString {
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

+(NSString*) generateRequestUrlPrefix: (NSString*) method: (NSArray*) params {
    assert(method != NULL);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?api_key=%@&api_secret=%@", SERVER_ADDRESS, method, FACEPP_API_KEY, FACEPP_API_SECRET];
    if (params != NULL) {
        assert((params.count%2)==0);
        for (int i=0; i<params.count; i+=2) {
            [urlString appendFormat:@"&%@=%@", [params objectAtIndex:i], [params objectAtIndex:i+1]];
        }
    }
    
    return urlString;
}

+(FaceppResult*) requestWithParameters: (NSString*) method: (NSArray*) params {
    if (!initilized)
        return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:NOT_INIT_ERROR_MSG andHttpStatusCode:0 andErrorCode:0]];
    
    NSError *error = nil;
    NSInteger statusCode = 0;
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [FaceppClient generateRequestUrlPrefix: method: params];
    [request setURL: [NSURL URLWithString:urlString]];
    if (debugMode)
        NSLog(@"[FacePlusPlus]request url: \n%@", [request URL]);
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    statusCode = urlResponse.statusCode;

    return [FaceppClient generateResultWithResponseData:responseData error:error httpStatusCode:statusCode];
}

+(FaceppResult*) requestWithImage: (NSString*)method: (NSData*) imageData: (NSArray*)params {
    if (!initilized)
        return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:NOT_INIT_ERROR_MSG andHttpStatusCode:0 andErrorCode:0]];

    NSError *error = NULL;
    NSInteger statusCode = 0;
    
    NSString *boundary = [self generateBoundaryString];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [[NSMutableData alloc] init];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"image.jpeg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    NSString *urlString = [FaceppClient generateRequestUrlPrefix:method : params];

    // set URL
    [request setURL: [NSURL URLWithString:urlString]];
    if (debugMode)
        NSLog(@"[FacePlusPlus]request url: \n%@", [request URL]);
    
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    statusCode = urlResponse.statusCode;
    
    return [FaceppClient generateResultWithResponseData:responseData error:error httpStatusCode:statusCode];
}

+(FaceppResult*) generateResultWithResponseData:(NSData*) responseData error:(NSError*) error httpStatusCode:(int)httpStatusCode {
    if (debugMode)
        NSLog(@"[FacePlusPlus]response JSON: \n%@", [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
    FaceppResult *result;
    
    if (responseData == nil) {
        result = [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:@"no response data" andHttpStatusCode:httpStatusCode andErrorCode:0]];
        return result;
    }
    
    NSError *jsonError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError != NULL) {
        if (error != NULL) {
            return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:[error description] andHttpStatusCode:httpStatusCode andErrorCode:0]];
        } else {
            return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:[jsonError description] andHttpStatusCode:httpStatusCode andErrorCode:0]];
        }
    }
    FaceppError *faceppError = [FaceppError checkErrorFromJSONDictionary:dict andHttpStatusCode:httpStatusCode];
    if (faceppError != NULL)
        return [FaceppResult resultWithSuccess:false :faceppError];
    result = [FaceppResult resultWithSuccess:true :nil];
    result.content = dict;
    
    if (error != NULL)
        return [FaceppResult resultWithSuccess:false :[FaceppError errorWithErrorMsg:[error description] andHttpStatusCode:httpStatusCode andErrorCode:0]];    
    
    return result;
}

@end
