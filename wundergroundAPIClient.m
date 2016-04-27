
//
//  wundergroundAPIClient.m
//  wethar
//
//  Created by Dylan Straughan on 4/26/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "wundergroundAPIClient.h"
#import "secrets.h"

@implementation wundergroundAPIClient

+(void)fetchCurrentConditionsWeatherDataForLocationWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(NSDictionary*data))completionBlock {
    
    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@/%@.json",WEATHER_API_KEY,state,city]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        completionBlock(dataToSend);
        
    }];
    
    [dataTask resume];
    
}

+(void)fetchTenDayWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSArray *))completionBlock {
    
    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/features/forecast10day/q/%@/%@.json",WEATHER_API_KEY,state,city]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *arrayOfDays = dataToSend[@"forecast"][@"simpleforecast"][@"forecastday"];
        
        completionBlock(arrayOfDays);
        
    }];
    
    [dataTask resume];
    
}

+(void)fetchHourlyWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSArray *))completionBlock {
    
    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/hourly/q/%@/%@.json",WEATHER_API_KEY,state,city]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *arrayOfHours = dataToSend[@"hourly_forecast"];
        
        completionBlock(arrayOfHours);
        
    }];
    
    [dataTask resume];
}

+(void)fetchCurrentDayWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSArray *))completionBlock {
    
    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/q/%@/%@.json",WEATHER_API_KEY,state,city]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *finalArray = dataToSend[@"forecast"][@"simpleforecast"][@"forecastday"];
        
        completionBlock(finalArray);
        
    }];
    
    [dataTask resume];
}



@end
