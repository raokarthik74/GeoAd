//
//  FBLoginViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import MediaPlayer;
@import AVKit;
@import AVFoundation;

@interface FBLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end
