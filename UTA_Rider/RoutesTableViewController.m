//
//  RoutesTableViewController.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 2/21/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "RoutesTableViewController.h"
#import "Route.h"
#import "RouteCustomCell.h"
#import "TabBarViewController.h"
#import "MapViewController.h"
#import "Utilities.h"
#import "Stop.h"

@interface RoutesTableViewController ()

@end

@implementation RoutesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // Fixed the table going under the status bar by going to the storyboard
    // then selecting the tableview and modifing the "Top Content insets" to 20 from 0
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Utilities reportPageOpenToAnalytics:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    BOOL isFavoritesUpdated = [defaults boolForKey:KEY_FAVORITES_UPDATED];
    NSData *routesFavoriteData = [defaults objectForKey:KEY_ROUTES_FAVORITE];
    self.arrayOfFavoriteRoutes = [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:routesFavoriteData]];
    
    if (self.arrayOfFavoriteRoutes && self.allRoutes)
    {
        for (Route *eachRoute in self.allRoutes)
        {
            [eachRoute setIsFavoriteRoute:NO];
        }
        
        for (Route *routeFavorite in self.arrayOfFavoriteRoutes)
        {
//            NSLog(@"favorite route = %@", routeFavorite.routeId);
            for (Route *eachRoute in self.allRoutes)
            {
                if (routeFavorite.routeId == eachRoute.routeId)
                {
                    [eachRoute setIsFavoriteRoute:YES];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

- (IBAction)onFavoriteSelected:(id)sender
{
    UIButton *buttonFavorite = sender;
    long tag = buttonFavorite.tag;
    BOOL routeDeleted = NO;
    
    if (self.arrayOfFavoriteRoutes)
    {
        for (Route *routeFavorite in self.arrayOfFavoriteRoutes)
        {
            if (tag == [routeFavorite.routeId longLongValue])
            {
                [self.arrayOfFavoriteRoutes removeObject:routeFavorite];
                [buttonFavorite setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
                routeDeleted = YES;
                break;
            }
        }
    }
    
    if (!routeDeleted)
    {
        for (Route *route in self.allRoutes)
        {
            if (tag == [route.routeId integerValue])
            {
                if (!self.arrayOfFavoriteRoutes)
                {
                    self.arrayOfFavoriteRoutes = [[NSMutableArray alloc]init];
                }
                [self.arrayOfFavoriteRoutes addObject:route];
                break;
            }
        }
        [buttonFavorite setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateNormal];
    }
    
    
    // need to serialize arrayOfFavoriteRoutes first
    NSArray *arrayOfFavoriteRoutesRegularArray = [NSArray arrayWithArray:self.arrayOfFavoriteRoutes];
    NSData *data = [[NSData alloc]init];
    data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfFavoriteRoutesRegularArray];
    [defaults setObject:data forKey:KEY_ROUTES_FAVORITE];
    [defaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            return [self.routes_trax count];
            break;
        case 1:
            return [self.routes_frontrunner count];
            break;
        case 2:
            return [self.routes_bus count];
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Trax lines";
            break;
        case 1:
            return @"Frontrunner";
            break;
        case 2:
            return @"Bus routes";
            break;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RouteCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Route *singleRoute;
    switch (indexPath.section)
    {
        case 0:
            singleRoute = [self.routes_trax objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            cell.buttonFavoriteAsOutlet.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.isEnabled];
            if (singleRoute.isFavoriteRoute)
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
            }
            break;
        case 1:
            singleRoute = [self.routes_frontrunner objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            cell.buttonFavoriteAsOutlet.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.isEnabled];
            if (singleRoute.isFavoriteRoute)
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            singleRoute = [self.routes_bus objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            cell.buttonFavoriteAsOutlet.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.isEnabled];
            if (singleRoute.isFavoriteRoute)
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.buttonFavoriteAsOutlet setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
            }
            break;
    }
    return cell;
}

@end



















































