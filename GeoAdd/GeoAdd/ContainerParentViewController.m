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
@property(strong, nonatomic) AddDisplayViewController *add;

@end

@implementation ContainerParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(displayAd)
                                                       userInfo:nil
                                                        repeats:NO];
    NSTimer *myTimer1 = [NSTimer scheduledTimerWithTimeInterval:200
                                                         target:self
                                                       selector:@selector(displayAd)
                                                       userInfo:nil
                                                        repeats:YES];
    // Do any additional setup after loading the view.
}

-(id)init
{
    if (self = [super init]) {
       self.add = [[AddDisplayViewController init]alloc];
    }
    return self;
}

-(void)displayAd{
    self.adChild.hidden = NO;
    self.buttonBack.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    self.adChild.hidden = YES;
    self.buttonBack.hidden = YES;
}

@end











