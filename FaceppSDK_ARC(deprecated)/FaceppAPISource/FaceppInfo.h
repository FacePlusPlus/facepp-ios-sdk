//
//  FaceppInfo.h
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppInfo : NSObject

-(FaceppResult*) getApp;
-(FaceppResult*) getFaceWithFaceId:(NSString*)faceId;
-(FaceppResult*) getGroupList;
-(FaceppResult*) getImageWithImgId:(NSString*)imageId;
-(FaceppResult*) getPersonList;
-(FaceppResult*) getFacesetList;
-(FaceppResult*) getQuota;
-(FaceppResult*) getSessionWithSessionId:(NSString*)sessionId;

@end
