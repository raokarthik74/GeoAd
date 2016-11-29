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

@end

@implementation AddDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.view.hidden){
        [self.youtubePlayer stopVideo];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self locationAd];
    NSTimer *myTimer1 = [NSTimer scheduledTimerWithTimeInterval:200
                                                         target:self
                                                       selector:@selector(locationAd)
                                                       userInfo:nil
                                                        repeats:YES];
}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
    [self.youtubePlayer playVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationAd{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: @"(-118.28406,34.02167)",@"location",@"skyline",@"type", nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"webviewsegue"]) {
        WebViewController *controller = (WebViewController *)segue.destinationViewController;
        controller.clickurl = self.clickurl;
    }
}

@end
