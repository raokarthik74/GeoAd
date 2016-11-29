//
//  ContainerParentViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/28/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDisplayViewController.h"

@interface ContainerParentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *adChild;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)backButton:(id)sender;

@end
