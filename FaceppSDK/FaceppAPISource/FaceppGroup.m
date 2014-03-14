//
//  FaceppGroup.m
//  ImageCapture
//
//  Created by youmu on 12-11-27.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "FaceppGroup.h"
#import "FaceppClient.h"

@implementation FaceppGroup

-(FaceppResult*) addPersonWithGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andPersonId:(NSArray*)personId orPersonName:(NSArray*) personName {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if ((personId != nil) && ([personId count]>0)) {
        [params addObject:@"person_id"];
        NSMutableString *persons = [NSMutableString stringWithString:[personId objectAtIndex:0]];
        for (int i=1; i<[personId count]; i++)
            [persons appendFormat:@",%@", [personId objectAtIndex:i]];
        [params addObject:persons];
    }
    if ((personName != nil) && ([personName count]>0)) {
        [params addObject:@"person_name"];
        NSMutableString *persons = [NSMutableString stringWithString:[personName objectAtIndex:0]];
        for (int i=1; i<[personName count]; i++)
            [persons appendFormat:@",%@", [personName objectAtIndex:i]];
        [params addObject:persons];
    }
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    return [FaceppClient requestWithMethod:@"group/add_person" params:params];

}

-(FaceppResult*) createWithGroupName:(NSString*) groupName {
    return [self createWithGroupName:groupName andTag:nil andPersonId:nil orPersonName:nil];
}

-(FaceppResult*) createWithGroupName:(NSString*) groupName andTag:(NSString*)tag andPersonId:(NSArray*)personId orPersonName:(NSArray*)personName {
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"group_name", groupName, nil];
    if ((personId != nil) && ([personId count]>0)) {
        [params addObject:@"person_id"];
        NSMutableString *persons = [NSMutableString stringWithString:[personId objectAtIndex:0]];
        for (int i=1; i<[personId count]; i++)
            [persons appendFormat:@",%@", [personId objectAtIndex:i]];
        [params addObject:persons];
    }
    if ((personName != nil) && ([personName count]>0)) {
        [params addObject:@"person_name"];
        NSMutableString *persons = [NSMutableString stringWithString:[personName objectAtIndex:0]];
        for (int i=1; i<[personName count]; i++)
            [persons appendFormat:@",%@", [personName objectAtIndex:i]];
        [params addObject:persons];
    }
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    return [FaceppClient requestWithMethod:@"group/create" params:params];    
}

-(FaceppResult*) deleteWithGroupName:(NSString*) groupName orGroupId:(NSString*)groupId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    return [FaceppClient requestWithMethod:@"group/delete" params:params];
}

-(FaceppResult*) getInfoWithGroupName:(NSString*) groupName orGroupId:(NSString*)groupId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    return [FaceppClient requestWithMethod:@"group/get_info" params:params];    
}

-(FaceppResult*) getInfoUngroupedPersons {
    return [self getInfoWithGroupName:nil orGroupId:@"none"];
}

-(FaceppResult*) removePersonWithGroupName:(NSString*)groupName orGroupId:(NSString*)groupId andPersonName:(NSArray*)personName orPersonId:(NSArray*)personId {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    if ((personId != nil) && ([personId count]>0)) {
        [params addObject:@"person_id"];
        NSMutableString *persons = [NSMutableString stringWithString:[personId objectAtIndex:0]];
        for (int i=1; i<[personId count]; i++)
            [persons appendFormat:@",%@", [personId objectAtIndex:i]];
        [params addObject:persons];
    }
    if ((personName != nil) && ([personName count]>0)) {
        [params addObject:@"person_name"];
        NSMutableString *persons = [NSMutableString stringWithString:[personName objectAtIndex:0]];
        for (int i=1; i<[personName count]; i++)
            [persons appendFormat:@",%@", [personName objectAtIndex:i]];
        [params addObject:persons];
    }
    return [FaceppClient requestWithMethod:@"group/remove_person" params:params];
}

-(FaceppResult*) removeAllPersonWithGroupName:(NSString*)groupName orGroupId:(NSString*)groupId {
    return [self removePersonWithGroupName:groupName orGroupId:groupId andPersonName:nil orPersonId:[NSArray arrayWithObject: @"all"]];
}

-(FaceppResult*) setInfoWithGroupId:(NSString*)groupId orGroupName:(NSString*)groupName andName:(NSString*)name andTag:(NSString*)tag {
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:10];
    if (groupId != nil) {
        [params addObject:@"group_id"];
        [params addObject:groupId];
    }
    if (groupName != nil) {
        [params addObject:@"group_name"];
        [params addObject:groupName];
    }
    if (name != nil) {
        [params addObject:@"name"];
        [params addObject:name];
    }
    if (tag != nil) {
        [params addObject:@"tag"];
        [params addObject:tag];
    }
    return [FaceppClient requestWithMethod:@"group/set_info" params:params];    
}

@end
