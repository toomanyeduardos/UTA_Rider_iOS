//
//  FavoritesTVC.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 1/6/16.
//  Copyright © 2016 Eduardo Flores. All rights reserved.
//

#import "FavoritesTVC.h"
#import "Route.h"
#import "RouteCustomCell.h"
#import "Utilities.h"

@interface FavoritesTVC ()

@end

@implementation FavoritesTVC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Utilities reportPageOpenToAnalytics:NSStringFromClass([self class])];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfFavoriteRoutes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    Route *route = [self.arrayOfFavoriteRoutes objectAtIndex:indexPath.row];

    cell.label_routeName.text = route.routeLongName;
    cell.label_routeDetail.text = route.routeShortName;
    cell.buttonFavoriteAsOutlet.tag = [route.routeId integerValue];
    cell.buttonFavoriteAsOutlet.indexPath = indexPath;
    [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateNormal];
    cell.switch_routeSwitch.tag = [route.routeId integerValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Favorite Routes";
}

- (IBAction)onFavoriteSelected:(id)sender
{
    CustomButton *buttonFavorite = sender;
    long tag = buttonFavorite.tag;
    
    if (self.arrayOfFavoriteRoutes)
    {
        for (Route *routeFavorite in self.arrayOfFavoriteRoutes)
        {
            if (tag == [routeFavorite.routeId longLongValue])
            {
                [self.arrayOfFavoriteRoutes removeObject:routeFavorite];
                [buttonFavorite setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    // need to serialize arrayOfFavoriteRoutes first
    NSArray *arrayOfFavoriteRoutesRegularArray = [NSArray arrayWithArray:self.arrayOfFavoriteRoutes];
    NSData *data = [[NSData alloc]init];
    data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfFavoriteRoutesRegularArray];
    [defaults setObject:data forKey:KEY_ROUTES_FAVORITE];
    [defaults setBool:YES forKey:KEY_FAVORITES_UPDATED];
    [defaults synchronize];
    
    [self.tableView deleteRowsAtIndexPaths:@[buttonFavorite.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


@end
