//
//  FaceppPerson.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppPerson : NSObject

-(FaceppResult*) addFaceWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andFaceId:(NSArray*)faceId;

-(FaceppResult*) create;
-(FaceppResult*) createWithPersonName:(NSString*)personName andFaceId:(NSArray*)faceId andTag:(NSString*)tag andGroupId:(NSArray*)groupId orGroupName:(NSArray*)groupName;

-(FaceppResult*) deleteWithPersonName:(NSString*)personName orPersonId:(NSString*)personId;

-(FaceppResult*) getInfoWithPersonName:(NSString*)personName orPersonId:(NSString*)personId;

-(FaceppResult*) removeAllFaceWithPersonName:(NSString *)personName orPersonId:(NSString *)personId;
-(FaceppResult*) removeFaceWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andFaceId:(NSArray*)faceId;

-(FaceppResult*) setInfoWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andName:(NSString*)name andTag:(NSString*)tag;
@end
