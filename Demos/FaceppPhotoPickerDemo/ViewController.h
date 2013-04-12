//
//  ViewController.h
//  FaceppPhotoPickerDemo
//
//  Created by youmu on 12-12-5.
//  Copyright (c) 2012年 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceppAPI.h"

#define USE_FACEPP_OFFLINE_DETECTION

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *button;
    UIImagePickerController *imagePicker;
}

-(IBAction)pickFromCameraButtonPressed:(id)sender;
-(IBAction)pickFromLibraryButtonPressed:(id)sender;

-(void) detectWithImage: (UIImage*) image;

@end
