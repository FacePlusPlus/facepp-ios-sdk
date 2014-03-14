//
//  FaceppPerson.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppPerson.h"
#import "FaceppClient.h"

@implementation FaceppPerson

-(FaceppResult*) addFaceWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andFaceId:(NSArray*)faceId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if ((faceId != nil) && ([faceId count]>0)) {
        [params addObject:@"face_id"];
        NSMutableString *faces = [NSMutableString stringWithString:[faceId objectAtIndex:0]];
        for (int i=1; i<[faceId count]; i++)
            [faces appendFormat:@",%@", [faceId objectAtIndex:i]];
        [params addObject:faces];
    }
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    return [FaceppClient requestWithMethod:@"person/add_face" params:params];
}

-(FaceppResult*) create {
    return [FaceppClient requestWithMethod:@"person/create" params:nil];
}

-(FaceppResult*) createWithPersonName:(NSString*)personName andFaceId:(NSArray*)faceId andTag:(NSString*)tag andGroupId:(NSArray*)groupId orGroupName:(NSArray*)groupName {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    if ((groupId != nil) && ([groupId count]>0)) {
        [params addObject:@"group_id"];
        NSMutableString *groupds = [NSMutableString stringWithString:[groupId objectAtIndex:0]];
        for (int i=1; i<[groupId count]; i++)
            [groupds appendFormat:@",%@", [groupId objectAtIndex:i]];
        [params addObject:groupds];
    }
    if ((groupName != nil) && ([groupName count]>0)) {
        [params addObject:@"group_name"];
        NSMutableString *groupds = [NSMutableString stringWithString:[groupName objectAtIndex:0]];
        for (int i=1; i<[groupName count]; i++)
            [groupds appendFormat:@",%@", [groupName objectAtIndex:i]];
        [params addObject:groupds];
    }
    if ((faceId != nil) && ([faceId count]>0)) {
        [params addObject:@"face_id"];
        NSMutableString *faces = [NSMutableString stringWithString:[faceId objectAtIndex:0]];
        for (int i=1; i<[faceId count]; i++)
            [faces appendFormat:@",%@", [faceId objectAtIndex:i]];
        [params addObject:faces];
    }
    return [FaceppClient requestWithMethod:@"person/create" params:params];
}

-(FaceppResult*) deleteWithPersonName:(NSString*)personName orPersonId:(NSString*)personId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    return [FaceppClient requestWithMethod:@"person/delete" params:params];
}

-(FaceppResult*) getInfoWithPersonName:(NSString*)personName orPersonId:(NSString*)personId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    return [FaceppClient requestWithMethod:@"person/get_info" params:params];
}

-(FaceppResult*) removeAllFaceWithPersonName:(NSString *)personName orPersonId:(NSString *)personId {
    return [self removeFaceWithPersonName:personName orPersonId:personId andFaceId:[NSArray arrayWithObject:@"all"]];
}

-(FaceppResult*) removeFaceWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andFaceId:(NSArray*)faceId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if ((faceId != nil) && ([faceId count]>0)) {
        [params addObject:@"face_id"];
        NSMutableString *faces = [NSMutableString stringWithString:[faceId objectAtIndex:0]];
        for (int i=1; i<[faceId count]; i++)
            [faces appendFormat:@",%@", [faceId objectAtIndex:i]];
        [params addObject:faces];
    }
    return [FaceppClient requestWithMethod:@"person/remove_face" params:params];

}

-(FaceppResult*) setInfoWithPersonName:(NSString*)personName orPersonId:(NSString*)personId andName:(NSString*)name andTag:(NSString*)tag {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (personId != nil) {
        [params addObject:@"person_id"];
        [params addObject:personId];
    }
    if (personName != nil) {
        [params addObject:@"person_name"];
        [params addObject:personName];
    }
    if (name != nil) {
        [params addObject:@"name"];
        [params addObject:name];
    }
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    return [FaceppClient requestWithMethod:@"person/set_info" params:params];
}

@end
