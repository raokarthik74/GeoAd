//
//  AddDisplayViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "AddDisplayViewController.h"

@interface AddDisplayViewController ()

@property (strong, nonatomic) NSString *addID;
@property (strong, nonatomic) NSString *queryType;
@property CLLocationManager *locationManager;
@property CLGeocoder *geoCoder;
@property CLPlacemark *placeMark;
@property CLLocation* currentLocation;

@end

@implementation AddDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.youtubePlayer.delegate = self;
    self.view.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self adManager];
}
-(void)adManager{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Query Type"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* skyline = [UIAlertAction actionWithTitle:@"Skyline" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        self.queryType = @"skyline";
                                                        NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                                                            target:self
                                                                                                          selector:@selector(locationCollector)
                                                                                                          userInfo:nil
                                                                                                           repeats:NO];
                                                    }];
    UIAlertAction* nn = [UIAlertAction actionWithTitle:@"NN" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   self.queryType = @"nn";
                                                   NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                                                       target:self
                                                                                                     selector:@selector(locationCollector)
                                                                                                     userInfo:nil
                                                                                                      repeats:NO];
                                               }];
    UIAlertAction* random = [UIAlertAction actionWithTitle:@"Random" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                                                           target:self
                                                                                                         selector:@selector(locationCollector)
                                                                                                         userInfo:nil
                                                                                                          repeats:NO];
                                                   }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];

    [alert addAction:skyline];
    [alert addAction:nn];
    [alert addAction:random];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
    [self.youtubePlayer playVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self locationAd];
    [self.locationManager stopUpdatingLocation];
}

-(void)locationAd{
    self.view.hidden = NO;
    NSMutableString *loc = [[NSMutableString alloc]init];
    [loc appendString:@"("];
    [loc appendString:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude]];
    [loc appendString:@","];
    [loc appendString:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude]];
    [loc appendString:@")"];
    NSString *finalLoc = loc;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: finalLoc,@"location",self.queryType,@"type", nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonData %@",dic );
    NSDictionary *headers = @{ @"content-type": @"application/json" };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-160-50-16.us-west-2.compute.amazonaws.com:8080/v1/ad/getad"]
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
                                                        // NSLog(@"data %@", data);
                                                        NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:kNilOptions
                                                                                                                   error:NULL];
                                                        NSLog(@"JSON data %@", jsonDataArray);
                                                        NSDictionary *dictObject = [jsonDataArray objectAtIndex:0];
                                                        NSLog(@"value for country %@", [dictObject objectForKey:@"videourl"]);
                                                        self.url = [dictObject objectForKey:@"videourl"];
                                                        self.clickurl = [dictObject objectForKey:@"clickurl"];
                                                        self.adname = [dictObject objectForKey:@"name"];
                                                        NSLog(@"url %@", self.url);
                                                        self.adId = [dictObject objectForKey:@"id"];
                                                        self.youtubePlayer.delegate = self;
                                                        NSDictionary *playerVars = @{
                                                                                     @"playsinline" : @1,
                                                                                     @"autoplay" : @1,
                                                                                     @"showinfo" : @0,
                                                                                     @"rel" : @0,
                                                                                     @"modestbranding" : @1,
                                                                                     };
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.youtubePlayer loadWithVideoId:self.url playerVars:playerVars];
                                                            self.addID = (NSString *)self.adId;
                                                            [self.clickbutton setTitle:self.adname forState:UIControlStateNormal];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
    
}


- (IBAction)clickToView:(id)sender {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: self.addID,@"id", nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonData %@",dic );
    NSDictionary *headers = @{ @"content-type": @"application/json" };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-160-50-16.us-west-2.compute.amazonaws.com:8080/v1/ad/clickad"]
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
                                                        // NSLog(@"data %@", data);
                                                        NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:kNilOptions
                                                                                                                   error:NULL];
                                                        NSLog(@"JSON data %@", jsonDataArray);
                                                        NSDictionary *dictObject = [jsonDataArray objectAtIndex:0];
                                                        NSLog(@"value for country %@", [[dictObject objectForKey:@"amountLeft"] stringValue]);
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStateEnded:
            NSLog(@"Paused playback");
            [self.youtubePlayer stopVideo];
            self.view.hidden = YES;
            NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                                target:self
                                                              selector:@selector(adManager)
                                                              userInfo:nil
                                                               repeats:NO];
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"webviewsegue"]) {
        WebViewController *controller = (WebViewController *)segue.destinationViewController;
        controller.clickurl = self.clickurl;
        controller.titleNav = self.adname;
    }
}

@end
