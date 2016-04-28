//
//  DVSCurrentDay.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSCurrentDay.h"

@implementation DVSCurrentDay

+(instancetype)createDVSCurrentDayFromDictionary:(NSDictionary *)dictionary {
    
    DVSCurrentDay *finalDay = [[DVSCurrentDay alloc]init];
    
    finalDay.highTemp =[dictionary[@"high"][@"fahrenheit"]floatValue];
    finalDay.lowTemp =[dictionary[@"low"][@"fahrenheit"]floatValue];
    finalDay.dayCondition =dictionary[@"conditions"];
    finalDay.dayIcon =nil;
    finalDay.date = [NSDate date];
    
    return finalDay;
    
}


@end
