//
//  TwitterViewController.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "MBProgressHUD.h"

@interface TwitterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate>
{
    NSArray *tweets;
    
    NSMutableArray *arrayOfParsedTweets;
    
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;

- (void) getTweetsFromTwitter;
- (void) parseTweets;
@end
