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
@property int tapCount;
@property int longcount;
@property CLLocationManager *locationManager;
@property CLGeocoder *geoCoder;
@property CLPlacemark *placeMark;
@property CLLocation* currentLocation;
@property GMSCameraPosition *camera;
@property NSMutableString *locationString;
@property NSString *finalLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationCollector];
    self.polygonArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self.longcount<1) {
        self.tapCount++;
        CLLocationCoordinate2D position = coordinate;
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Hello World";
        marker.map = mapView;
        CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.polygonArray addObject:location];
        NSLog(@"object added and current count is %lu", (unsigned long)self.polygonArray.count);
    }
}

- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
        self.longcount++;
    if(self.longcount<2){
        self.locationString = [[NSMutableString alloc]init];
        [self.locationString appendString:@"("];
        GMSMutablePath *rect = [GMSMutablePath path];
        for (int i=0; i<self.polygonArray.count; i++) {
            [rect addCoordinate:[[self.polygonArray objectAtIndex:i]coordinate]];
            [self.locationString appendString:@"("];
            [self.locationString appendString:[NSString stringWithFormat:@"%f", [[self.polygonArray objectAtIndex:i]coordinate].longitude]];
            [self.locationString appendString:@","];
            [self.locationString appendString:[NSString stringWithFormat:@"%f", [[self.polygonArray objectAtIndex:i]coordinate].latitude]];
            [self.locationString appendString:@"),"];
        }
        [self.locationString deleteCharactersInRange:NSMakeRange([self.locationString length]-1, 1)];
        [self.locationString appendString:@")"];
        
        self.finalLocation = self.locationString;
        NSLog(@"location string %@", self.finalLocation);
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
        polygon.strokeColor = [UIColor blackColor];
        polygon.strokeWidth = 2;
        polygon.map = mapView;
    }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                           message:@"Your ad was posted successfully"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self buildad];
                                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
}

-(void)locationCollector {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [locations lastObject];
    NSLog(@"last latitude %f", self.currentLocation.coordinate.latitude);
    NSLog(@"last longitude %f", self.currentLocation.coordinate.longitude);
    self.camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                              longitude:self.currentLocation.coordinate.longitude
                                                   zoom:18];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:self.camera];
    self.view = mapView;
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Steps"
                                                                   message:@"Tap clockwise or anti-clockwise on the map. Each Tap will generate a marker. When you are done marking coordinates, Long tap anywhere on the map. This will generate a fence. If you are satisfied with the fence, again Long tap anywhere, to complete ad build"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self.locationManager stopUpdatingLocation];
}

-(void)buildad{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.adName,@"name", self.country, @"country",self.budget, @"budget", self.personId, @"personId",@"video", @"type", self.youtubeId, @"videourl",self.clickUrl, @"clickurl", self.locationString,@"fence",nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonData %@",dic );
    NSDictionary *headers = @{ @"content-type": @"application/json" };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-160-50-16.us-west-2.compute.amazonaws.com:8080/v1/ad/buildad"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
