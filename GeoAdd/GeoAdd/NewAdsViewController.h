//
//  NewAdsViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "TabBarController.h"

@interface NewAdsViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextField *budget;

@property (weak, nonatomic) IBOutlet UITextField *onClickUrl;

@property (weak, nonatomic) IBOutlet UITextField *youtubeId;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;









@end
