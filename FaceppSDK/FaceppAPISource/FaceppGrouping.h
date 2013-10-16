//
//  FaceppGrouping.h
//  FaceppSDK+Demo
//
//  Created by youmu on 13-4-12.
//  Copyright (c) 2013 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppGrouping : NSObject

-(FaceppResult*) groupingWithFacesetId:(NSString*) facesetId orFacesetName:(NSString*)facesetName;

@end
