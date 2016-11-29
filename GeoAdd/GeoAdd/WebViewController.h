//
//  WebViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/16/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property(strong, nonatomic) NSString *clickurl;
@property(strong, nonatomic) NSString *titleNav;

- (IBAction)dismiss:(id)sender;

@end
