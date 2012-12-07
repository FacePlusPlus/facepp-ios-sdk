//
//  FacePPClient.h
//  ImageCapture
//
//  Created by youmu on 12-10-25.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FaceppResult.h"

@interface FaceppClient : NSObject

+(void) setDebugMode:(BOOL) on;
+(void) initializeWithApiKey: (NSString*)apiKey apiSecret:(NSString*) apiSecret;

+(FaceppResult*) requestWithParameters: (NSString*)method: (NSArray*)params;
+(FaceppResult*) requestWithImage: (NSString*)method: (NSData*)imageData: (NSArray*)params;

@end
