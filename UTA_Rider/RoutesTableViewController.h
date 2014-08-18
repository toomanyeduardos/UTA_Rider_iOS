//
//  RoutesTableViewController.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 2/21/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RoutesTableViewController : UITableViewController <CLLocationManagerDelegate>
{
    // Location variables
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSUserDefaults *defaults;
    
    NSMutableArray *allRoutes;
    NSMutableArray *arrayOfRoutesEnabled;
    
    NSMutableArray *allStops;
    
    NSMutableArray *routes_trax;
    NSMutableArray *routes_bus;
    NSMutableArray *routes_frontrunner;
}

- (IBAction)switchEnableRoute:(id)sender;

@end
