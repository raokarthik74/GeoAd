//
//  PreviewAdViewController.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewTableViewCell.h"

@interface PreviewAdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
