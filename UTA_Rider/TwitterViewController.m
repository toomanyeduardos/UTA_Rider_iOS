//
//  TwitterViewController.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "TwitterViewController.h"
#import "STTwitterAPI.h"
#import "Tweet.h"
#import "TwitterCustomCell.h"

#define TWITTER_KEY         @"JjppSoLTt7CDDWGegs8SWqSo6"
#define TWITTER_SECRET      @"KogEjVNm2sztW3V3DQuMJYWRSp3Sh6PtBAvfsv6aBGOYn50c2s"
#define TWITTER_SCREEN_NAME @"RideUTA"

@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.adView.delegate = self;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    [self getTweetsFromTwitter];

}

- (void)getTweetsFromTwitter
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_KEY
                                                            consumerSecret:TWITTER_SECRET];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         //NSLog(@"access granted for username = %@", username);
         
         [twitter getUserTimelineWithScreenName:TWITTER_SCREEN_NAME
                                          count:50
                                   successBlock:^(NSArray *statuses)
          {
              tweets = statuses;
              [self parseTweets];
              
          }
                                     errorBlock:^(NSError *error)
          {
              NSLog(@"error = %@", error);
          }];
     }
                                    errorBlock:^(NSError *error)
     {
         NSLog(@"error = %@", error);
     }];
}

- (void) parseTweets
{
    arrayOfParsedTweets = [[NSMutableArray alloc]init];
    
    for (NSDictionary *tweet in tweets)
    {
        // get screen_name for specific tweet
        NSDictionary *user = [tweet objectForKey:@"user"];
        NSString *screen_name = [user objectForKey:@"screen_name"];
        
        // look for links in the tweet
        NSError *error = NULL;
        NSURL *url = nil;
        NSString *string = [tweet objectForKey:@"text"];
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *matches = [detector matchesInString:string
                                             options:0
                                               range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in matches)
        {
            if ([match resultType] == NSTextCheckingTypeLink)
            {
                url = [match URL];
            }
        }
        
        // Format date/time of the created_at field from twitter
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //Wed Dec 01 17:08:03 +0000 2010
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [df dateFromString:[tweet objectForKey:@"created_at"]];
        [df setDateFormat:@"eee MMM dd yyyy, h:mm a"];
        NSString *dateStr = [df stringFromDate:date];
        
        Tweet *newTweet = [[Tweet alloc]init];
        [newTweet setTweet_title:[tweet objectForKey:@"text"]];
        [newTweet setTweet_date:dateStr];
        [newTweet setTweet_screenName:screen_name];
        [newTweet setTweet_url:url];
        
        [arrayOfParsedTweets addObject:newTweet];
    }
    [self.tableview reloadData];
    
    [HUD hide:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfParsedTweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwitter" forIndexPath:indexPath];

    Tweet *tweet = [arrayOfParsedTweets objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tweet.tweet_url)
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.tweet_screenName.text = [NSString stringWithFormat:@"#%@", tweet.tweet_screenName];
    cell.tweet_text.text = tweet.tweet_title;
    cell.tweet_date.text = tweet.tweet_date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Tweet *tweet = [arrayOfParsedTweets objectAtIndex:indexPath.row];
    
    if (tweet.tweet_url)
        [[UIApplication sharedApplication] openURL:tweet.tweet_url];
}

#pragma mark - iAd
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self.adView setAlpha:1];
    [UIView commitAnimations];
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self.adView setAlpha:0];
    [UIView commitAnimations];
}

@end













































