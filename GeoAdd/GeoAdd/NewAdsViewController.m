//
//  NewAdsViewController.m
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "NewAdsViewController.h"

@interface NewAdsViewController ()

@end

@implementation NewAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText.delegate = self;
    self.budget.delegate = self;
    self.onClickUrl.delegate = self;
    self.youtubeId.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.titleText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.budget addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.onClickUrl addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.youtubeId addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self.titleText isFirstResponder] && [tapGestureRecognizer view] != self.titleText) {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.titleText resignFirstResponder];
    }
    if ([self.budget isFirstResponder] && [tapGestureRecognizer view] != self.budget) {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.budget resignFirstResponder];
    }
    if ([self.onClickUrl isFirstResponder] && [tapGestureRecognizer view] != self.onClickUrl) {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.onClickUrl resignFirstResponder];
    }
    if ([self.youtubeId isFirstResponder] && [tapGestureRecognizer view] != self.youtubeId) {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.youtubeId resignFirstResponder];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.titleText){
        [self.budget becomeFirstResponder];
    }
    if(textField == self.budget){
        [self.onClickUrl becomeFirstResponder];
    }
    if(textField == self.onClickUrl){
        [self.youtubeId becomeFirstResponder];
    }
    if(textField == self.youtubeId){
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [self.youtubeId resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField*)textField{
    
    if (self.titleText.text.length > 0 && self.budget.text.length > 0 && self.onClickUrl.text.length > 0 && self.youtubeId.text.length > 0){
        
        self.doneButton.enabled = YES;
        
    } else {
        
        self.doneButton.enabled = NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"fenceSegue"]) {
        ViewController *controller = (ViewController *)segue.destinationViewController;
        TabBarController *tabCon = (TabBarController*)self.tabBarController;
        controller.adName = self.titleText.text;
        controller.budget = self.budget.text;
        controller.clickUrl = self.onClickUrl.text;
        controller.youtubeId = self.youtubeId.text;
        controller.personId = tabCon.personId;
        controller.country = tabCon.country;
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"fenceSegue" sender:self];
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
