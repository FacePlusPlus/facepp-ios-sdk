//
//  FaceppGroup.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppResult.h"

@interface FaceppGroup : NSObject

-(FaceppResult*) addPersonWithGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andPersonId:(NSArray*)personId orPersonName:(NSArray*) personName;

-(FaceppResult*) createWithGroupName:(NSString*) groupName;
-(FaceppResult*) createWithGroupName:(NSString*) groupName andTag:(NSString*)tag andPersonId:(NSArray*)personId orPersonName:(NSArray*)personName;

-(FaceppResult*) deleteWithGroupName:(NSString*) groupName orGroupId:(NSString*)groupId;

-(FaceppResult*) getInfoWithGroupName:(NSString*) groupName orGroupId:(NSString*)groupId;
-(FaceppResult*) getInfoUngroupedPersons;

-(FaceppResult*) removePersonWithGroupName:(NSString*)groupName orGroupId:(NSString*)groupId andPersonName:(NSArray*)personName orPersonId:(NSArray*)personId;
-(FaceppResult*) removeAllPersonWithGroupName:(NSString*)groupName orGroupId:(NSString*)groupId;

-(FaceppResult*) setInfoWithGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andName:(NSString*)name andTag:(NSString*)tag;

@end
