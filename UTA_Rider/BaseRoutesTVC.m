//
//  BaseRoutesTVC.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 1/7/16.
//  Copyright © 2016 Eduardo Flores. All rights reserved.
//

#import "BaseRoutesTVC.h"
#import "RouteCustomCell.h"
#import "Stop.h"
#import "Utilities.h"

@interface BaseRoutesTVC ()

@end

@implementation BaseRoutesTVC

@synthesize arrayOfFavoriteRoutes, arrayOfRoutesEnabled, allRoutes, allStops;
@synthesize routes_bus, routes_frontrunner, routes_trax;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *routesFavoriteData = [defaults objectForKey:KEY_ROUTES_FAVORITE];
    arrayOfFavoriteRoutes = [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:routesFavoriteData]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfRoutesEnabled = [[NSMutableArray alloc]init];
    allRoutes = [[NSMutableArray alloc]init];
    
    [self startGeolocation];
    
    [self parseStopsCSVFile];
    [self parseRoutesCSVFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) parseStopsCSVFile
{
    NSArray *rowsArray = [Utilities parseCSVFileWithFileName:@"stops" fileType:@"txt"];
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
    if (!defaults)
    {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    [defaults setObject:data forKey:KEY_STOPS_ALL];
}

- (void) parseRoutesCSVFile
{
    NSArray *rowsArray = [Utilities parseCSVFileWithFileName:@"routes" fileType:@"txt"];
    // delete the file header
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
        long routeType = [[eachRoute routeType]integerValue];
        
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

- (BOOL) isRouteInArrayOfRoutesEnabled:(Route *)routeParameter
{
    for (Route *route in arrayOfRoutesEnabled)
    {
        if (route == routeParameter)
            return YES;
    }
    return NO;
}

- (IBAction)switchEnableRoute:(id)sender
{
    UISwitch *switchInCell = sender;
    
    // take the tag of the array
    long tag = switchInCell.tag;
    
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
    if (!defaults)
    {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    [defaults setObject:data forKey:KEY_ROUTES_ENABLED];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - Geolocation Methods
- (void) startGeolocation
{
    locationManager = [[CLLocationManager alloc]init];
    
    [locationManager requestWhenInUseAuthorization];
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", lastLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", lastLocation.coordinate.longitude];
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











































