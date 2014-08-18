//
//  TwitterCustomCell.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "TwitterCustomCell.h"

@implementation TwitterCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
