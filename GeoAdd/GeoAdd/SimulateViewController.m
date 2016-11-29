//
//  SimulateViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "SimulateViewController.h"

@interface SimulateViewController ()

@end

@implementation SimulateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.02167
                                                            longitude:-118.28406
                                                                 zoom:18];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
