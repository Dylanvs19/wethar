//
//  DVSDatastore.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSDatastore.h"
@import CoreLocation;

@interface DVSDatastore () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation * location;

@end

@implementation DVSDatastore

+ (instancetype)sharedDatastore {
    
    static DVSDatastore *_sharedPiratesDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPiratesDataStore = [[DVSDatastore alloc] init];
    });
    
    return _sharedPiratesDataStore;
}

-(instancetype)init
{
    self = [super init];
    
    if(self) {
        
        
    }
    
    return self;
}

-(void)getTenDayForcastWithCompletion:(void(^)(BOOL))completionBlock{
    
    self.tenDayWeatherForecast = [[NSMutableArray alloc]init];
    
    [wundergroundAPIClient fetchTenDayWeatherForecastWithCity:self.urlCity state:self.state andCompletionBlock:^(NSArray *data) {
        
        NSUInteger count = data.count;
        
        for (NSDictionary *day in data) {
            
            [self.tenDayWeatherForecast addObject:[DVSTenDayWeatherDay createDVSTenDayWeatherDayFromDictionary:day]];
            
            count--;
        }
        
        if (count == 0) {
            
            completionBlock(YES);
        }
        
    }];
    
}

-(void)getCurrentDayForcastWithCompletion:(void(^)(BOOL))completionBlock{
    
    [wundergroundAPIClient fetchCurrentDayWeatherForecastWithCity:self.urlCity state:self.state andCompletionBlock:^(NSArray *data) {
       
        NSDictionary *currentDayDictionary = [data firstObject];
        
        self.currentDay = [DVSCurrentDay createDVSCurrentDayFromDictionary:currentDayDictionary];
        
        completionBlock(YES);
        
    }];
}

-(void)getCurrentConditionsForcastWithCompletion:(void(^)(BOOL))completionBlock{
    
    [wundergroundAPIClient fetchCurrentConditionsWeatherDataForLocationWithCity:self.urlCity state:self.state andCompletionBlock:^(NSDictionary *data) {
       
        self.currentConditions = [DVSCurrentForecast createDVSCurrentForecastFromDictionary:data];
        
        completionBlock(YES);

    }];
}

-(void)getHourlyForcastWithCompletion:(void(^)(BOOL))completionBlock{
    
    self.tenDayWeatherForecast = [[NSMutableArray alloc]init];
    
    [wundergroundAPIClient fetchHourlyWeatherForecastWithCity:self.urlCity state:self.state andCompletionBlock:^(NSArray *data) {
        
        NSUInteger count = data.count;
        
        for (NSDictionary *day in data) {
            
            [self.tenDayWeatherForecast addObject:[DVSTenDayWeatherDay createDVSTenDayWeatherDayFromDictionary:day]];
            
            count--;
        }
        
        if (count == 0) {
            
            completionBlock(YES);
        }
        
    }];
}

-(void)getLocation{
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
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
        
        NSUInteger count = placemarks.count;
        
        for (CLPlacemark * placemark in placemarks) {
            
            self.city = [placemark locality]; // locality means "city"
            if ([self.city containsString:@" "]) {
                
                self.urlCity = [self.city stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            }
            
            self.state = [placemark administrativeArea]; // which is "state" in the U.S.A.
         
            count --;
        }
        
        if (count == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"locationInfoComplete" object:nil];
        }
    }];
    
    
}





@end
