//
//  BaseRoutesTVC.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 1/7/16.
//  Copyright © 2016 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"
#import "SharedKeys.h"
#import <CoreLocation/CoreLocation.h>

@interface BaseRoutesTVC : UITableViewController <CLLocationManagerDelegate>
{
    NSUserDefaults *defaults;
    
    // Location variables
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (nonatomic, retain) NSMutableArray *arrayOfFavoriteRoutes;
@property (nonatomic, retain) NSMutableArray *arrayOfRoutesEnabled;
@property (nonatomic, retain) NSMutableArray *allRoutes;
@property (nonatomic, retain) NSMutableArray *allStops;
@property (nonatomic, retain) NSMutableArray *routes_trax;
@property (nonatomic, retain) NSMutableArray *routes_bus;
@property (nonatomic, retain) NSMutableArray *routes_frontrunner;

- (IBAction)switchEnableRoute:(id)sender;

- (void) parseStopsCSVFile;
- (void) parseRoutesCSVFile;
- (BOOL) isRouteInArrayOfRoutesEnabled:(Route *)routeParameter;

@end
