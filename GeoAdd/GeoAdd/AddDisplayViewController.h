//
//  AddDisplayViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "WebViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TabBarController.h"

@interface AddDisplayViewController : UIViewController <YTPlayerViewDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayer;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) NSString *clickurl;
@property(strong, nonatomic) NSString *adname;
@property(strong, nonatomic) id adId;
@property (weak, nonatomic) IBOutlet UIButton *clickbutton;

- (IBAction)clickToView:(id)sender;

@end
