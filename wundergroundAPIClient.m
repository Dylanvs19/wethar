
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

+(void)fetchAllWeatherInformationCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSDictionary * data, BOOL success))completionBlock {
    
    NSURL *weatherApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/features/conditions/forecast/forecast10day/hourly/q/%@/%@.json",WEATHER_API_KEY,state,city]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:weatherApi completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        NSDictionary *dataToSend = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (httpResponse.statusCode == 200){
        
            completionBlock(dataToSend, YES);
            
        } else {
            
            completionBlock(dataToSend, NO);
        }
        
        
    }];
    
    [dataTask resume];
    

    
    
}



@end
