//
//  FaceppAPI.h
//  FaceppSDK+Demo
//
//  Created by youmu on 12-11-28.
//  Copyright (c) 2012 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceppDetection.h"
#import "FaceppGroup.h"
#import "FaceppInfo.h"
#import "FaceppPerson.h"
#import "FaceppRecognition.h"
#import "FaceppTrainer.h"
#import "FaceppFaceset.h"
#import "FaceppGrouping.h"

typedef enum APIServerRegion{
    APIServerRegionCN,
    APIServerRegionUS
} APIServerRegion;

@interface FaceppAPI : NSObject

/*! 
 * @brief Initialize FacePlusPlus client with your API_KEY and API_SECRET, and specific your region
 * @code
 *  - (void)applicationDidFinishLaunching:(UIApplication *)application
 {
 // Facepp startup methods
 [FaceppAPI initWithApiKey: @"YOUR_API_KEY" andApiSecret:@"YOUR_API_SECRET" andRegion:APIServerRegionXX];
 // ....
 }
 * @endcode
 */
+(void)initWithApiKey:(NSString*) apiKey andApiSecret:(NSString*) apiSecret andRegion:(APIServerRegion) region;

/*!
 * @brief Indicate whether debug message will be printed.
 */
+(void)setDebugMode:(BOOL) on;

/*!
 * @brief The object which contains all methods about detection
 */
+(FaceppDetection*) detection;

/*!
 * @brief The object which contains all methods about train
 */
+(FaceppTrainer*) train;

/*!
 * @brief The object which contains all methods about recognition
 */
+(FaceppRecognition*) recognition;

/*!
 * @brief The object which contains all methods about faceset
 */
+(FaceppFaceset*) faceset;

/*!
 * @brief The object which contains all methods about person
 */
+(FaceppPerson*) person;

/*!
 * @brief The object which contains all methods about group
 */
+(FaceppGroup*) group;

/*!
 * @brief The object which contains all methods about info
 */
+(FaceppInfo*) info;

/*!
 * @brief The object which contains all methods about info
 */
+(FaceppGrouping*) grouping;

@end
