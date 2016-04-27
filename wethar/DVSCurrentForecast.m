//
//  DVSCurrentForecast.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSCurrentForecast.h"
#import <UIKit/UIKit.h>

@implementation DVSCurrentForecast

+(instancetype)createDVSCurrentForecastFromDictionary:(NSDictionary *)dictionary {
    
    DVSCurrentForecast *current = [[DVSCurrentForecast alloc]init];
    
    current.currentTemp = [dictionary[@"current_observation"][@"temp_f"]floatValue];
    current.currentCondition = dictionary[@"current_observation"][@"weather"];
    current.currentIcon = nil;
    current.currentHumidity = [dictionary[@"current_observation"][@"relative_humidity"]floatValue];
    current.currentWindSpeed = [dictionary[@"current_observation"][@"wind_mph"]floatValue];
    current.currentWindSpeedDirection = dictionary[@"current_observation"][@"wind_dir"];
    current.feelsLikeTemp = [dictionary[@"current_observation"][@"feelslike_f"]floatValue];
    
    return current;
    
}


@end
