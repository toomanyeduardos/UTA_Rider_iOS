//
//  TwitterCustomCell.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweet_date;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *tweet_screenName;
@end
