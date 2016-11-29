//
//  ContainerParentViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/28/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "ContainerParentViewController.h"

@interface ContainerParentViewController ()

@property(strong, nonatomic) NSString* url;
@property(strong, nonatomic) NSString* clickurl;
@property(strong, nonatomic) NSString* adname;
@property(strong, nonatomic) id adId;

@end

@implementation ContainerParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                                                        
                                                    }
                                                }];
    NSTimer *myTimer1 = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(segueToSimulate)
                                                       userInfo:nil
                                                        repeats:NO];
    
    [dataTask resume];
    
}

@end
