//
//  PreviewTableViewCell.h
//  GeoAdd
//
//  Created by Karthik Rao on 11/27/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface PreviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayer;
@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet UILabel *clickRate;
@property (weak, nonatomic) IBOutlet UILabel *impressionCount;
@property (weak, nonatomic) IBOutlet UILabel *ctr;

@end
