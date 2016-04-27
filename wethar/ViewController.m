//
//  ViewController.m
//  wethar
//
//  Created by Dylan Straughan on 4/25/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "ViewController.h"
#import "secrets.h"
#import "wundergroundAPIClient.h"
#import "flickrAPIClient.h"
#import <UIImageView+AFNetworking.h>

@import CoreLocation;


@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *urlCity;
@property (strong, nonatomic) IBOutlet UILabel *TempLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *flickrImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLocation];
    
    
}

- (void)updateTheLabelsWithWeatherDataFromCurrentLocation {
    
    wundergroundAPIClient *client = [[wundergroundAPIClient alloc]init];
    
    [client fetchWeatherDataForLocationWithCity:self.urlCity state:self.state andCompletionBlock:^(NSDictionary *data) {
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",self.state, self.city];
            self.TempLabel.text = [NSString stringWithFormat:@"%@",data[@"current_observation"][@"temp_f"]];
            
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ([error code] != kCLErrorLocationUnknown) {
                [self.locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.location= [locations lastObject];
    self.latitude= [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            self.city = [placemark locality]; // locality means "city"
            if ([self.city containsString:@" "]) {
                
                self.urlCity = [self.city stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            }
            
            self.state = [placemark administrativeArea]; // which is "state" in the U.S.A.
            
        }

        [self updateTheLabelsWithWeatherDataFromCurrentLocation];
        [self setImageView];

    }];
    

}


-(void)setImageView{
    
    flickrAPIClient *APIClient = [[flickrAPIClient alloc]init];
    
    [APIClient  getPhotoFromFlickrWithLatitude:self.latitude longitude:self.longitude city:self.urlCity state:self.state andCompletionBlock:^(NSURL *image){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.flickrImage setImageWithURL:image];
            
            NSLog(@"%@",self.flickrImage);
            
        }];
        
    }];
  
    
}



@end
