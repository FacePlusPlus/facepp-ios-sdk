//
//  FaceppDetection.h
//  ImageCapture
//
//  Created by youmu on 12-11-26.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppResult.h"

typedef enum FaceppDetectionMode{
    FaceppDetectionModeNormal,
    FaceppDetectionModeOneFace
} FaceppDetectionMode;

typedef enum FaceppDetectionAttribute {
    FaceppDetectionAttributeAll,
    FaceppDetectionAttributeNone
} FaceppDetectionAttribute;

@interface FaceppDetection : NSObject

/*!
 *  @brief detect with a URL or from local image data.
 *  @param set a not NULL value to use url for detect
 *  @param imageData NULL to use URL for detection, not NULL to use local image data.
 */
-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data;
-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode;
-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute;
-(FaceppResult*) detectWithURL:(NSString*)url imageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag;

@end