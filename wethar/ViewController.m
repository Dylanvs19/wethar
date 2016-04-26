//
//  ViewController.m
//  wethar
//
//  Created by Dylan Straughan on 4/25/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "ViewController.h"
#import "secrets.h"
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
    [self fetchWeatherDataForLocationWithCompletionBlock:^(NSDictionary *data) {
        
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

// location manager delegate methods

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

    }];
    

}


-(void)fetchWeatherDataForLocationWithCompletionBlock:(void(^)(NSDictionary*data))completionBlock {

    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@/%@.json",WEATHER_API_KEY,self.state, self.urlCity]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        completionBlock(dataToSend);
        
    }];
    
    [dataTask resume];
    
}

-(void)getPhotoFromFlickrWithCompletionBlock:(void(^)(NSDictionary *))completionBlock {
    
    NSURL *flickerAPI = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services?api_key=%@&lat=%@&lon=%@",FLICKR_API_KEY,self.latitude,self.longitude]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:flickerAPI completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        NSDictionary * dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        completionBlock(dataToSend);
        
    }];
    
    [dataTask resume];
}


@end
