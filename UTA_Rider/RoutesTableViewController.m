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
    
    [self startGeolocation];

    arrayOfRoutesEnabled = [[NSMutableArray alloc]init];
}

-(void)awakeFromNib
{
    defaults = [NSUserDefaults standardUserDefaults];

    [self parseStopsCSVFile];
    [self parseRoutesCSVFile];
}

- (void) parseStopsCSVFile
{
    NSArray *rowsArray = [Utilities parseCSVFileWithFileName:@"stops" fileType:@"csv"];
    allStops = [[NSMutableArray alloc]init];
    
    for (NSArray *obj in rowsArray)
    {
        NSNumber *stop_id = [obj objectAtIndex:0];
        NSString *stop_code = [obj objectAtIndex:1];
        NSString *stop_name = [obj objectAtIndex:2];
        NSString *stop_description = [obj objectAtIndex:3];
        NSNumber *stop_latitude = [obj objectAtIndex:4];
        NSNumber *stop_longitude = [obj objectAtIndex:5];
        
        Stop *singleStop = [[Stop alloc]init];
        singleStop.stopId = stop_id;
        singleStop.stopCode = stop_code;
        singleStop.stopName = stop_name;
        singleStop.stopDescription = stop_description;
        singleStop.stopLatitude = stop_latitude;
        singleStop.stopLongitude = stop_longitude;
        
        [allStops addObject:singleStop];
    }
    
    // need to serialize allStops first
    NSArray *arrayOfAllStops = [NSArray arrayWithArray:allStops];
    NSData *data = [[NSData alloc]init];
    data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfAllStops];
    [defaults setObject:data forKey:@"allStops"];
}

- (void) parseRoutesCSVFile
{
    NSArray *rowsArray = [Utilities parseCSVFileWithFileName:@"routes" fileType:@"csv"];
    allRoutes = [[NSMutableArray alloc]init];
    
    for (NSArray *obj in rowsArray)
    {
        NSNumber *route_id = [obj objectAtIndex:0];
        NSString *route_short_name = [obj objectAtIndex:2];
        NSString *route_long_name = [obj objectAtIndex:3];
        NSNumber *route_type = [obj objectAtIndex:5];
        
        Route *singleRoute = [[Route alloc]init];
        singleRoute.routeId = route_id;
        singleRoute.routeLongName = route_long_name;
        singleRoute.routeShortName = route_short_name;
        singleRoute.routeType = route_type;
        
        [allRoutes addObject:singleRoute];
    }
    
    // create an array for each route type
    routes_bus = [[NSMutableArray alloc]init];
    routes_frontrunner = [[NSMutableArray alloc]init];
    routes_trax = [[NSMutableArray alloc]init];
    
    for (Route *eachRoute in allRoutes)
    {
        int routeType = [[eachRoute routeType]integerValue];
        
        switch (routeType)
        {
            case 0:
                [routes_trax addObject:eachRoute];
                break;
            case 1:
                break;
            case 2:
                [routes_frontrunner addObject:eachRoute];
                break;
            case 3:
                [routes_bus addObject:eachRoute];
                break;
        }
    }
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
            return [routes_trax count];
            break;
        case 1:
            return [routes_frontrunner count];
            break;
        case 2:
            return [routes_bus count];
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
            singleRoute = [routes_trax objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.getIsEnabled];
            break;
        case 1:
            singleRoute = [routes_frontrunner objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.getIsEnabled];
            break;
        case 2:
            singleRoute = [routes_bus objectAtIndex:indexPath.row];
            cell.label_routeName.text = singleRoute.routeLongName;
            cell.label_routeDetail.text = singleRoute.routeShortName;
            cell.switch_routeSwitch.tag = [singleRoute.routeId integerValue];
            [cell.switch_routeSwitch setOn:singleRoute.getIsEnabled];
            break;
    }
    return cell;
}

- (IBAction)switchEnableRoute:(id)sender
{
    UISwitch *switchInCell = sender;
    
    //NSLog(@"on? = %d", [switchInCell isOn]);
    //NSLog(@"switch tag = %d", switchInCell.tag);
    
    // take the tag of the array
    int tag = switchInCell.tag;
    
    // check to see if the arrayOfRoutesEnabled has this selected route in the array
    for (Route *route in allRoutes)
    {
        if (tag == [route.routeId integerValue])
        {
            // if the route is not in the array it means that the route hasn't been selected yet
            // add route to array and set value of isEnabled to yes
            if ( ![self isRouteInArrayOfRoutesEnabled:route])
            {
                [arrayOfRoutesEnabled addObject:route];
                [route setIsEnabled:YES];
            }
            else    // remove route from array and set isEnabled value to no
            {
                [arrayOfRoutesEnabled removeObject:route];
                [route setIsEnabled:NO];
            }
        }
    }
    
    // need to serialize setObject:arrayOfRoutesEnabled first
    NSArray *routesEnabledAsRegularArray = [NSArray arrayWithArray:arrayOfRoutesEnabled];
    NSData *data = [[NSData alloc]init];
    data = [NSKeyedArchiver archivedDataWithRootObject:routesEnabledAsRegularArray];
    [defaults setObject:data forKey:@"arrayOfRoutesEnabled"];
    
}

- (BOOL) isRouteInArrayOfRoutesEnabled:(Route *)routeParameter
{
    for (Route *route in arrayOfRoutesEnabled)
    {
        if (route == routeParameter)
            return YES;
    }
    return NO;
}

#pragma mark - Geolocation Methods
- (void) startGeolocation
{
    locationManager = [[CLLocationManager alloc]init];
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed)
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"Location services are enabled on this device, but this app is not allowed to us them"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            geocoder = [[CLGeocoder alloc] init];
            
            [locationManager setDelegate:self];
            
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager setDistanceFilter:50];
            
            [locationManager startUpdatingLocation];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
//    NSLog(@"latitude = %@", latitude);
//    NSLog(@"longitude = %@", longitude);
    
    [defaults setObject:latitude forKey:@"latitude"];
    [defaults setObject:longitude forKey:@"longitude"];
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error locationManager = %@", error);
}


@end



















































