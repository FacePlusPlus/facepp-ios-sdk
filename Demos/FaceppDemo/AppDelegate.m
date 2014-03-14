//
//  AppDelegate.m
//  FaceppDemo
//
//  Created by youmu on 12-11-28.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import "AppDelegate.h"
#import "FaceppAPI.h"
#import "../APIKey+APISecret.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (NSString*) getPhotoURL:(int) index {
    return [NSString stringWithFormat:@"http://www.faceplusplus.com.cn/wp-content/themes/faceplusplus/assets/img/demo/%d.jpg", index+1];
}

- (NSString*) getTraningURL:(int) index {
    return [NSString stringWithFormat:@"http://www.faceplusplus.com.cn/wp-content/themes/faceplusplus/assets/img/demo/%d.jpg", index+1];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ////////////////////////////////////////////////////////////////////////////////
    //                      FacePlusPlus ios sdk demo
    ////////////////////////////////////////////////////////////////////////////////
    NSString *API_KEY = _API_KEY;
    NSString *API_SECRET = _API_SECRET;
    
    // initialize
    [FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET andRegion:APIServerRegionCN];
    
    // turn on the debug mode
    [FaceppAPI setDebugMode:TRUE];
    
    NSArray *personNames = [NSArray arrayWithObjects:@"Alice", @"Bob", @"Ethan", nil];
    NSMutableArray *personIds = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *faceIds = [NSMutableArray arrayWithCapacity:10];
    NSString *face_id = nil;
    
    // DETECTION
    for (int i=0; i<[personNames count]; i++) {
        // delete person if exists
        [[FaceppAPI person] deleteWithPersonName:[personNames objectAtIndex:i] orPersonId:nil];
        // create new person, detect faces from person's image_url
        FaceppResult *detectLocalFileResult = [[FaceppAPI detection] detectWithURL: [self getTraningURL:i]
                                                                         orImageData: nil];
        if ([detectLocalFileResult success]) {
            int face_count = [[detectLocalFileResult content][@"face"] count];
            if (face_count > 0) {
                face_id = [detectLocalFileResult content][@"face"][0][@"face_id"];
                [faceIds addObject:face_id];
                FaceppResult *personResult = [[FaceppAPI person] createWithPersonName: [personNames objectAtIndex:i]
                                                                            andFaceId: [NSArray arrayWithObject:face_id]
                                                                               andTag: nil
                                                                           andGroupId: nil
                                                                          orGroupName: nil];
                if ([personResult success]) {
                    NSString *person_id = [personResult content][@"person_id"];
                    [personIds addObject:person_id];
                }
            }
        } else {
            // something wrong
            FaceppError *error = [detectLocalFileResult error];
            NSLog(@"Error message: %@", [error message]);
        } 
    }
    
    // create a new group, add persons into group
    NSString *groupName = @"sampe_group";
    [[FaceppAPI group] deleteWithGroupName: groupName
                                 orGroupId: nil];
    [[FaceppAPI group] createWithGroupName: groupName
                                    andTag: nil
                               andPersonId: personIds
                              orPersonName: nil];
    
    // generate training model for group
    [[FaceppAPI train] trainSynchronouslyWithId:nil
                                         orName:groupName
                                        andType:FaceppTrainIdentify
                                refreshDuration:1.0f
                                        timeout:10.0f];
    
    // recognize
    [[FaceppAPI recognition] identifyWithGroupId:nil
                                     orGroupName:groupName
                                          andURL:[self getPhotoURL:0]
                                     orImageData:nil
                                     orKeyFaceId:nil
                                           async:NO];

    // create a new faceset, add faces into faceset
    NSString* facesetName = @"sample_faceset";
    [[FaceppAPI faceset] deleteWithFacesetName:facesetName orFacesetId:nil];
    [[FaceppAPI faceset] createWithFacesetName:facesetName andFaceId:faceIds andTag:nil];
    [[FaceppAPI train] trainSynchronouslyWithId:nil
                                         orName:facesetName
                                        andType:FaceppTrainSearch
                                refreshDuration:1.0f
                                        timeout:10.0f];
    
    // search
    [[FaceppAPI recognition] searchWithKeyFaceId:face_id andFacesetId:nil orFacesetName:facesetName];
    
    
    //////////////////////////////////////////////////////////
    // FaceppResult example
    //////////////////////////////////////////////////////////
    // double face_width = [[detectLocalFileResult content][@"face"][0][@"width"] doubleValue];
    // double img_width = [[detectLocalFileResult content][@"img_width"] doubleValue];
    // double face_width_in_pixel = face_width * img_width * 0.01f;
    
    
    
    //////////////////////////////////////////////////////////
    // DETECTION example
    //////////////////////////////////////////////////////////
    //  [[FaceppAPI detection] detectWithURL:nil imageData:[NSData dataWithContentsOfFile:@"FILE_PATH"]];
    
    
    
    //////////////////////////////////////////////////////////
    // PERSON example
    //////////////////////////////////////////////////////////

    //    [[FaceppAPI person] deleteWithPersonName:@"NAME" orPersonId:nil];
    //    [[FaceppAPI person] createWithPersonName:@"NAME" andFaceId:[NSArray arrayWithObjects:@"ID1", @"ID2", nil] andTag:@"TAG" andGroupId:[NSArray arrayWithObject:@"GROUP_ID"] orGroupName:nil];
    //    [[FaceppAPI person] removeFaceWithPersonName:nil orPersonId:@"ID1" andFaceId:[NSArray arrayWithObjects:@"756fb0f876d1e4c7d666c2450b843f6c", @"7b43a710e26e28258f0fa1ff60c7d37c", nil]];
    //    [[FaceppAPI person] removeAllFaceWithPersonName:nil orPersonId:nil];
    //    [[FaceppAPI person] addFaceWithPersonName:nil orPersonId:@"d01017823af0fea66f1400dbf248f0d3" andFaceId:[NSArray arrayWithObjects:@"756fb0f876d1e4c7d666c2450b843f6c", @"7b43a710e26e28258f0fa1ff60c7d37c", nil]];
    //    [[FaceppAPI person] getInfoWithPersonName:nil orPersonId:@"d01017823af0fea66f1400dbf248f0d3"];
    //    [[FaceppAPI person] setInfoWithPersonName:nil orPersonId:@"d01017823af0fea66f1400dbf248f0d3" andName:@"new name" andTag:@"new tag"];
    
    
    
    /////////////////////////////////////////////////////////
    // GROUP example
    /////////////////////////////////////////////////////////

    //    [[FaceppAPI group] createWithGroupName:@"demoGroup" andTag:@"groupfordemo" andPersonId:@"Id" orPersonName:nil];
    //    [[FaceppAPI group] deleteWithGroupName:@"demo" orGroupId:nil];
    //    [[FaceppAPI group] getInfoWithGroupName:nil orGroupId:@"3d1c81694d39765951209d8969702520"];
    //    [[FaceppAPI group] setInfoWithGroupId:nil orGroupName:@"demo" andName:@"demo" andTag:@"forDemo"];
    //    [[FaceppAPI group] addPersonWithGroupId:@"3d1c81694d39765951209d8969702520" orGroupName:@"demo" andPersonId:[NSArray arrayWithObject:@"d01017823af0fea66f1400dbf248f0d3"] orPersonName:[NSArray arrayWithObject:@"youmu"]];
    //    [[FaceppAPI group] removeAllPersonWithGroupName:@"demo" orGroupId:nil];
    
    
    
    /////////////////////////////////////////////////////////
    // INFO example
    /////////////////////////////////////////////////////////
    /*
     [[FaceppAPI info] getApp];
     [[FaceppAPI info] getFaceWithFaceId:@"756fb0f876d1e4c7d666c2450b843f6c"];
     [[FaceppAPI info] getGroupList];
     [[FaceppAPI info] getImageWithImgId:@"img"];
     [[FaceppAPI info] getPersonList];
     [[FaceppAPI info] getQuota];
     [[FaceppAPI info] getSessionWithSessionId:@"SESSION_ID"];
     */
    
    

    /////////////////////////////////////////////////////////
    // RECOGNITION
    /////////////////////////////////////////////////////////
    
    //    FaceppResult* result = [[FaceppAPI recognition] compareWithFaceId1:@"756fb0f876d1e4c7d666c2450b843f6c" andId2:@"7b43a710e26e28258f0fa1ff60c7d37c"];
    //    [[FaceppAPI recognition] trainSynchronouslyWithGroupId:@"3d1c81694d39765951209d8969702520" orGroupName:@"demo" andType:FaceppRecognitionTrainTypeAll refreshDuration:2.0f timeout:10.0f];
    //    [[FaceppAPI recognition] trainWithGroupId:@"3d1c81694d39765951209d8969702520" orGroupName:@"demo" andType:FaceppRecognitionTrainTypeAll];
    //    [[FaceppAPI recognition] recognizeWithGroupId:@"3d1c81694d39765951209d8969702520" orGroupName:@"demo" andURL:nil orImageData:nil/*[NSData dataWithContentsOfFile:@"/Users/yangmu/Desktop/test/img/W020090714369836507637.jpg"]*/ orKeyFaceId:[NSArray arrayWithObjects:@"756fb0f876d1e4c7d666c2450b843f6c", @"7b43a710e26e28258f0fa1ff60c7d37c", nil]];
    //    [[FaceppAPI recognition] verifyWithFaceId:@"756fb0f876d1e4c7d666c2450b843f6c" andPersonId:nil orPersonName:@"zhoujielun"];
    
    ////////////////////////////////////////////////////////////////////////////////
    //                              END
    ////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
