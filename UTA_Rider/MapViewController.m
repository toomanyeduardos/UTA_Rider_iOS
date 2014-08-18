//
//  MapViewController.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 3/31/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "MapViewController.h"
#import "AnnotationView.h"
#import "UTA_API_VEHICLE.h"
#import "Route.h"
#import "Stop.h"
#import "AnnotationObject.h"
#import "VehicleFromAPI.h"

#define SPAN_VALUE 0.05

#define MURRAY_LATITUDE 40.6669
#define MURRAY_LONGITUDE -111.8872
#define METERS_TO_MILES 0.00062137


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView, arrayOfRoutesEnabled, allStops, arrayOfVehiclesFromAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // deleting all annotations
    [mapView removeAnnotations:mapView.annotations];
    
    dispatch_queue_t downloader = dispatch_queue_create("initializer", NULL);
    dispatch_async(downloader, ^{
        
        [self displayUserLocationOnMap];
        
        NSData *stopsData = [defaults objectForKey:@"allStops"];
        allStops = [NSKeyedUnarchiver unarchiveObjectWithData:stopsData];
        
        NSData *routesData = [defaults objectForKey:@"arrayOfRoutesEnabled"];
        arrayOfRoutesEnabled = [NSKeyedUnarchiver unarchiveObjectWithData:routesData];
        
        [self generateAnnotationsForVehicles];

    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adView.delegate = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    latitude = [[defaults objectForKey:@"latitude"]doubleValue];
    longitude = [[defaults objectForKey:@"longitude"]doubleValue];
    
    [mapView setShowsUserLocation:YES];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                      target:self
                                                    selector:@selector(generateAnnotationsForVehicles)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void) displayUserLocationOnMap
{
    [self.mapView setDelegate:self];
    
    // region
    MKCoordinateRegion region;
    
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.latitudeDelta = SPAN_VALUE;
    region.span.longitudeDelta = SPAN_VALUE;
    [self.mapView setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:MKUserLocation.class])
    {
        //it's the built-in user location annotation, return nil to get default blue dot...
        return nil;
    }
    // create view (pin)
    AnnotationView *view = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    return view;
}//end mapView viewForAnnotation

- (void)generateAnnotationsForVehicles
{
    // This will use the NSArray *arrayOfRoutesEnabled as it's data source
    // This arrayOfRoutesEnabled gets reloaded every time this viewWillAppear
    dispatch_queue_t downloader = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloader, ^{
        
        // deleting all annotations
        [mapView removeAnnotations:mapView.annotations];
        
        // I have an array of route short names (this gives us the 703 number) that need to be downloaded
        // Download each route per each route short name
        // Repeat this for each route id
        for (Route *route in arrayOfRoutesEnabled)
        {
            NSMutableArray *locationOfVehiclesForRoute = [self downloadLocationOfVehiclesForRouteShortName:route.routeShortName routeType:route.routeType];
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView addAnnotations:locationOfVehiclesForRoute];
            });
        }
        // Repeat this for each route id
    });
}

- (NSMutableArray *) downloadLocationOfVehiclesForRouteShortName:(NSString *)routeShortName routeType:(NSNumber *)routeType
{
    //NSLog(@"shortName = %@", routeShortName);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // This will return an array of annotations per vehicle, per route
    
    UTA_API_VEHICLE *vehicle = [[UTA_API_VEHICLE alloc]init];
    AnnotationObject *annotation;
    NSMutableArray *annotationArray = [[NSMutableArray alloc]init];
    
    NSData *vehicleData = [vehicle getVehicleMonitorForRouteNumber:routeShortName];
    [vehicle parseVehicleMonitorData:vehicleData];
    
    NSString *destinationAsString = @"No Info";
    
    // This loop returns arrays of each element in the SIRI API
    // Build individual vehicles from here
    for (int i = 0; i < [[vehicle lineRef_arr]count]; i++)
    {
        VehicleFromAPI *vehicleObject = [[VehicleFromAPI alloc]init];
        
        vehicleObject.routeId = [[vehicle lineRef_arr]objectAtIndex:i];
        vehicleObject.routeShortName = [[vehicle publishedLineName_arr]objectAtIndex:i];
        
        
        for (Stop *stop in allStops)
        {
//            NSLog(@"stopCode = %@", stop.stopCode);
//            NSLog(@"destination = %@", [[vehicle destinationRef_arr]objectAtIndex:i]);
            if ([stop.stopCode isEqual:[[vehicle destinationRef_arr]objectAtIndex:i]])
            {
                location.latitude = [stop.stopLatitude doubleValue];
                location.longitude = [stop.stopLongitude doubleValue];
                destinationAsString = stop.stopName;
                
                annotation = [[AnnotationObject alloc]init];
                [annotation setCoordinate:location];
                annotation.title = [NSString stringWithFormat:@"%@", destinationAsString];
                
                annotation.routeType = [NSNumber numberWithInt:99];
                
                [annotationArray addObject:annotation];
            }
        }
        
        
        location.latitude = [[[vehicle latitude_arr]objectAtIndex:i]doubleValue];
        location.longitude = [[[vehicle longitude_arr]objectAtIndex:i]doubleValue];
        annotation = [[AnnotationObject alloc]init];
        [annotation setCoordinate:location];
        annotation.title = [NSString stringWithFormat:@"TO %@", destinationAsString];
        
        if ([routeType integerValue] > 10)
            routeType = [NSNumber numberWithInt:99];
        
        annotation.routeType = routeType;
        
        [annotationArray addObject:annotation];

    }
    
    //loop for [vehicle stopPointRef_arr]
    // build an annotation for each station found in this array
    NSArray *stopPointRef = [vehicle stopPointRef_arr];
    //NSLog(@"stopPointRef count = %d", [stopPointRef count]);
    //NSLog(@"stopPointRef = %@", stopPointRef);
    
    for (int i = 0; i < [stopPointRef count]; i++)
    {
        for (Stop *stop in allStops)
        {
            if ([stop.stopId integerValue] == [[stopPointRef objectAtIndex:i]integerValue])
            {
                location.latitude = [stop.stopLatitude doubleValue];
                location.longitude = [stop.stopLongitude doubleValue];
                destinationAsString = stop.stopName;
                
                annotation = [[AnnotationObject alloc]init];
                [annotation setCoordinate:location];
                annotation.title = [NSString stringWithFormat:@"%@", destinationAsString];
                
                annotation.routeType = [NSNumber numberWithInt:99];
                
                [annotationArray addObject:annotation];

            }
        }
    }
    // Once a route has been downloaded, parse its content and then the route returns a new array of annotations
    // pass this new array of annotations to the annotation display method

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return annotationArray;
}


#pragma mark - iAd
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
@end














































