//
//  hourlyForcastHour.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSHourlyForcastHour.h"

@implementation DVSHourlyForcastHour

+(instancetype)createDVSHourlyForcastHourFromDictionary:(NSDictionary *)dictionary{
    
    DVSHourlyForcastHour *finalHour = [[DVSHourlyForcastHour alloc]init];
    
    finalHour.hour = dictionary[@"FCTTIME"][@"civil"];
    finalHour.temp = dictionary[@"FCTTIME"][@"temp"][@"english"];
    finalHour.conditions = dictionary[@"FCTTIME"][@"condition"];
    finalHour.hourIcon = nil;
    
    return finalHour;
    
}


@end
