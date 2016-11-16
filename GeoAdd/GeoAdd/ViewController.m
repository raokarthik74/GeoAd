//
//  ViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSMutableArray* polygonArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.polygonArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    //add view on top of existing map to draw polygon
    mapView.delegate = self;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    NSLog(@"tapped");
    CLLocationCoordinate2D position = coordinate;
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Hello World";
    marker.map = mapView;
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    if ([self.polygonArray count] <4) {
        [self.polygonArray addObject:location];
        NSLog(@"object added and current count is %lu", (unsigned long)self.polygonArray.count);
    }
    else{
        GMSMutablePath *rect = [GMSMutablePath path];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:0]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:1]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:2]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:3]coordinate]];
        
        // Create the polygon, and assign it to the map.
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
        polygon.strokeColor = [UIColor blackColor];
        polygon.strokeWidth = 2;
        polygon.map = mapView;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
