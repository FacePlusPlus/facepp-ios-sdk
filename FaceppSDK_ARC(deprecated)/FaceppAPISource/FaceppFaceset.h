//
//  FaceppFaceset.h
//  FaceppSDK+Demo
//
//  Created by youmu on 13-4-12.
//  Copyright (c) 2013年 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppFaceset : NSObject

-(FaceppResult*) addFaceWithFacesetName:(NSString*)facesetName orFacesetId:(NSString*)facesetId andFaceId:(NSArray*)faceId;

-(FaceppResult*) create;
-(FaceppResult*) createWithFacesetName:(NSString*)facesetName andFaceId:(NSArray*)faceId andTag:(NSString*)tag;

-(FaceppResult*) deleteWithFacesetName:(NSString*)facesetName orFacesetId:(NSString*)facesetId;

-(FaceppResult*) getInfoWithFacesetName:(NSString*)facesetName orFacesetId:(NSString*)facesetId;

-(FaceppResult*) removeAllFaceWithFacesetName:(NSString *)facesetName orFacesetId:(NSString *)facesetId;
-(FaceppResult*) removeFaceWithFacesetName:(NSString*)facesetName orFacesetId:(NSString*)facesetId andFaceId:(NSArray*)faceId;

-(FaceppResult*) setInfoWithFacesetName:(NSString*)facesetName orFacesetId:(NSString*)facesetId andName:(NSString*)name andTag:(NSString*)tag;

@end
