//
//  MapViewController.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 3/31/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <ADBannerViewDelegate, MKMapViewDelegate>
{
    NSUserDefaults *defaults;
    
    // For annotations...
    CLLocationCoordinate2D location;
    
    double latitude;
    double longitude;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSArray *arrayOfRoutesEnabled;
@property (nonatomic, retain) NSArray *allStops;
@property (nonatomic, retain) NSArray *arrayOfVehiclesFromAPI;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;

- (void) displayUserLocationOnMap;
- (void) generateAnnotationsForVehicles;
- (NSMutableArray *) downloadLocationOfVehiclesForRouteShortName:(NSString *)routeShortName routeType:(NSNumber *)routeType;

@end