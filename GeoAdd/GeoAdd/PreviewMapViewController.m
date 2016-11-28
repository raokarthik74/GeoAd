//
//  PreviewMapViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "PreviewMapViewController.h"

@interface PreviewMapViewController ()

@property NSArray *jsonDataArray;

@end

@implementation PreviewMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAdForPerson];
}

- (void)loadAds {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-118.28406
                                                            longitude:34.02167
                                                                 zoom:1];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
    
    for (int j=0; j<self.jsonDataArray.count; j++) {
        NSDictionary *dictObject = [self.jsonDataArray objectAtIndex:j];
        NSString *fence = [dictObject objectForKey:@"fence"];
        fence = [[fence stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSLog(@"fence is %@", fence);
        NSArray *fenceArray = [fence componentsSeparatedByString:@","];
        GMSMutablePath *rect = [GMSMutablePath path];
        NSLog(@"fence %@", fenceArray);
        for (int i=0; i<fenceArray.count; i=i+2) {
            CLLocationCoordinate2D coord;
            coord.longitude = (CLLocationDegrees)[[fenceArray objectAtIndex:i] doubleValue];
            coord.latitude = (CLLocationDegrees)[[fenceArray objectAtIndex:i+1] doubleValue];
            [rect addCoordinate:coord];
        }
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
        polygon.strokeColor = [UIColor blackColor];
        polygon.strokeWidth = 2;
        polygon.map = mapView;
    }
}

-(void)getAdForPerson{
    TabBarController *tabCon = (TabBarController*)self.tabBarController;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:tabCon.personName,@"name",nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonData %@",dic );
    NSDictionary *headers = @{ @"content-type": @"application/json" };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-160-50-16.us-west-2.compute.amazonaws.com:8080/v1/person/getpersonads"]
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
                                                        self.jsonDataArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:NULL];
                                                        NSLog(@"JSON data %@", self.jsonDataArray);
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self loadAds];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
