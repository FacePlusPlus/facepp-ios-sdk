//
//  FaceppDetection.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-26.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import "FaceppResult.h"

typedef enum {
    FaceppDetectionModeDefault,
    FaceppDetectionModeNormal,
    FaceppDetectionModeOneFace
} FaceppDetectionMode;

enum {
    FaceppDetectionAttributeNone = 0,
    FaceppDetectionAttributeDefault = FaceppDetectionAttributeNone,
    FaceppDetectionAttributeAge = 1 << 0,
    FaceppDetectionAttributeRace = 1 << 1,
    FaceppDetectionAttributeGender = 1 << 2,
    FaceppDetectionAttributeSmiling = 1 << 3,
    FaceppDetectionAttributePose = 1 << 4,
    FaceppDetectionAttributeGlass = 1 << 5,
    FaceppDetectionAttributeAll = FaceppDetectionAttributeAge | FaceppDetectionAttributeRace | FaceppDetectionAttributeGender | FaceppDetectionAttributeSmiling
};
typedef int FaceppDetectionAttribute;

typedef enum {
    FaceppLandmark83P = 0,
    FaceppLandmark25P = 1
} FaceppLandmarkType;

@interface FaceppDetection : NSObject

/*!
 *  @brief detect with a URL or from local image data.
 *  @param set a not NULL value to use url for detect
 *  @param imageData NULL to use URL for detection, not NULL to use local image data.
 */
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data;
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode;
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute;
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag;
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag async:(BOOL)async;
-(FaceppResult*) detectWithURL:(NSString*)url orImageData:(NSData*)data mode:(FaceppDetectionMode)mode attribute:(FaceppDetectionAttribute)attribute tag:(NSString*)tag async:(BOOL)async others:(NSArray*) others;
-(FaceppResult*) landmarkWithFaceId: (NSString*) face andType:(FaceppLandmarkType) type;

@end
