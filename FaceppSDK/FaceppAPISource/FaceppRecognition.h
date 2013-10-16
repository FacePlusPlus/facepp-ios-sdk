//
//  FaceppRecognition.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppRecognition : NSObject

-(FaceppResult*) compareWithFaceId1:(NSString*)id1 andId2:(NSString*)id2 async:(BOOL)async;

-(FaceppResult*) identifyWithGroupId:(NSString*)groupId orGroupName:(NSString*)name andURL:(NSString*)url orImageData:(NSData*)data orKeyFaceId:(NSArray*)keyFaceId async:(BOOL)async;

-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andFacesetId:(NSString*)facesetId orFacesetName:(NSString*)facesetName;
-(FaceppResult*) searchWithKeyFaceId:(NSString*) keyFaceId andFacesetId:(NSString*)facesetId orFacesetName:(NSString*)facesetName andCount:(NSNumber*)count async:(BOOL)async;

-(FaceppResult*) verifyWithFaceId:(NSString*) faceId andPersonId:(NSString*)personId orPersonName:(NSString*)personName async:(BOOL)async;

@end
