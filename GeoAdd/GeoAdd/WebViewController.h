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

@property(strong, nonatomic) NSString *clickurl;
- (IBAction)dismiss:(id)sender;

@end
