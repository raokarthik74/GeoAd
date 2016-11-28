//
//  FBLoginViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "FBLoginViewController.h"

@interface FBLoginViewController ()

@property AVPlayer* avplayer;
@property UIActivityIndicatorView *activityView;
@property NSString *userName;
@property NSString *loc;
@property NSString *age;
@property NSString *personId;
@property NSData *dat;

@end

@implementation FBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self videoBackground];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions = @[@"public_profile", @"user_location"];
}

-(void)viewDidAppear:(BOOL)animated {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"name, age_range, location" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 self.userName = [result valueForKey:@"name"];
                 self.loc = [[result valueForKey:@"location"] valueForKey:@"name"];
                 self.age = [[result valueForKey:@"age_range"] valueForKey:@"min"];
                 if(!self.loc){
                     self.loc = @"USA";
                 }
                 if(!self.loc){
                     self.age = @"25";
                 }
                 NSLog(@"name is %@", self.userName);
                 NSLog(@"age is %@", self.loc);
                 NSLog(@"loc is %@", self.age);
             }
             NSDictionary *headers = @{ @"content-type": @"application/json" };
             NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: self.userName,@"name",self.loc,@"city", self.age,@"age",nil];
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-160-50-16.us-west-2.compute.amazonaws.com:8080/v1/person/addperson"]
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
                                                                 NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                          options:kNilOptions
                                                                                                                            error:NULL];
                                                                 NSLog(@"JSON data %@", jsonDataArray);
                                                                 NSDictionary *dictObject = [jsonDataArray objectAtIndex:0];
                                                                 self.personId = [[dictObject objectForKey:@"id"]stringValue];
                                                                 NSLog(@"personId %@", self.personId);
                                                                 [self performSegueWithIdentifier:@"loginSegue" sender:self];
                                                             }
                                                         }];
             [dataTask resume];
         }];
   }
}

- (void)videoBackground {
    //NSLog(@"Video background being called");
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mov"];
    self.avplayer = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.frame;
    controller.player = self.avplayer;
    controller.showsPlaybackControls = NO;
    [self.avplayer play];
    self.avplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"loginSegue"]) {
        TabBarController *controller = (TabBarController *)segue.destinationViewController;
        controller.personId = self.personId;
        controller.country = self.loc;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
