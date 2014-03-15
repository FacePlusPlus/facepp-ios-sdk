//
//  FaceppError.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceppError : NSObject

/*!
 *  @brief http status code
 */
@property int httpStatusCode;

/*!
 *  @brief error code which defined by FacePlusPlus
 */
@property int errorCode;

/*!
 *  @brief error message
 */
@property (nonatomic, strong) NSString* message;


-(id) initWithErrorMsg:(NSString*) msg andHttpStatusCode:(int)httpCode andErrorCode:(int) code;
+(id) errorWithErrorMsg:(NSString*) msg andHttpStatusCode:(int)httpCode andErrorCode:(int) code;
+(id) checkErrorFromJSONDictionary:(NSDictionary*) dict andHttpStatusCode:(int)httpCode;

@end
