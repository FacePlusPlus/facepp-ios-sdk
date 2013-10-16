//
//  FacePPClient.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-10-25.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FaceppResult.h"
#import "FaceppAPI.h"

@interface FaceppClient : NSObject

+(void) setDebugMode:(BOOL) on;
+(void) initializeWithApiKey: (NSString*)apiKey apiSecret:(NSString*) apiSecret region:(APIServerRegion)region;

+(FaceppResult*) requestWithParameters: (NSString*)method: (NSArray*)params;
+(FaceppResult*) requestWithImage: (NSString*)method: (NSData*)imageData: (NSArray*)params;

@end
