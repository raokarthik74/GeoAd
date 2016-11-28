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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.polygonArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.02167
                                                            longitude:-118.28406
                                                                 zoom:18];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    //add view on top of existing map to draw polygon
    mapView.delegate = self;
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView;
    [self buildad];
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    self.tapCount++;
    CLLocationCoordinate2D position = coordinate;
    if (self.tapCount >5) {
        GMSMutablePath *rect = [GMSMutablePath path];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:0]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:1]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:2]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:3]coordinate]];
        [rect addCoordinate:[[self.polygonArray objectAtIndex:4]coordinate]];
        // Create the polygon, and assign it to the map.
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
        polygon.strokeColor = [UIColor blackColor];
        polygon.strokeWidth = 2;
        polygon.map = mapView;
        if(self.tapCount>6){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                           message:@"Your ad was posted successfully"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    else{
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Hello World";
        marker.map = mapView;
        CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.polygonArray addObject:location];
        NSLog(@"object added and current count is %lu", (unsigned long)self.polygonArray.count);
    }
}

-(void)buildad{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Club Havana1",@"name", @"USA", @"country",@"10000", @"budget", @"2", @"personId",@"video", @"type", @"https://www.youtube.com/watch?v=w7IWLZcVU64", @"videourl", @"https://en.wikipedia.org/wiki/Casablanca_(film)", @"clickurl", @"((0,0),(0,10),(10, 10),(0, 0))",@"fence",nil];
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
