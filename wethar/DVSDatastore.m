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

-(void)getWeatherForcastWithCompletion:(void(^)(BOOL))completionBlock{
    
    self.tenDayWeatherForecast = [[NSMutableArray alloc]init];
    self.hourlyWeatherForecast = [[NSMutableArray alloc]init];
    
    
    [wundergroundAPIClient fetchAllWeatherInformationCity:self.urlCity state:self.state andCompletionBlock:^(NSDictionary *data, BOOL success) {
        
        if (success) {
            
            NSArray *tenDays = data[@"forecast"][@"simpleforecast"][@"forecastday"];
            
            NSUInteger tenDayCount = tenDays.count;
            
            for (NSDictionary *day in tenDays) {
                
                [self.tenDayWeatherForecast addObject:[DVSTenDayWeatherDay createDVSTenDayWeatherDayFromDictionary:day]];
                
                tenDayCount--;
            }
            
            NSDictionary *currentDayDictionary = [tenDays firstObject];
            
            self.currentDay = [DVSCurrentDay createDVSCurrentDayFromDictionary:currentDayDictionary];
            
            
            NSArray *hoursData = data[@"hourly_forecast"];
            
            NSUInteger count = hoursData.count;
            
            for (NSDictionary *day in hoursData) {
                
                [self.hourlyWeatherForecast addObject:[DVSHourlyForcastHour createDVSHourlyForcastHourFromDictionary:day]];
                
                count--;
            }
            
            self.currentConditions = [DVSCurrentForecast createDVSCurrentForecastFromDictionary:data];
            
            if (count == 0 && tenDayCount == 0){
                
                completionBlock(YES);
                
            }
            
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
            
            self.urlCity = self.city;
            
            if ([self.urlCity containsString:@" "]) {
                
                self.urlCity = [self.urlCity stringByReplacingOccurrencesOfString:@" " withString:@"_"];
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
