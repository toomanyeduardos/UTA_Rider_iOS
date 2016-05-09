//
//  RouteCustomCell.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 3/28/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RouteCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switch_routeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *label_routeName;
@property (weak, nonatomic) IBOutlet UILabel *label_routeDetail;
@property (weak, nonatomic) IBOutlet CustomButton *buttonFavoriteAsOutlet;

@end
