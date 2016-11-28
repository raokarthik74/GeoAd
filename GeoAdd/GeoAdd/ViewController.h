//
//  ViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <GMSMapViewDelegate>

@property (nonatomic,strong) NSString *adName;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *budget;
@property (nonatomic,strong) NSString *personId;
@property (nonatomic,strong) NSString *youtubeId;
@property (nonatomic,strong) NSString *clickUrl;


@end

