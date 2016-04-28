//
//  DVSTenDayWeatherDay.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSTenDayWeatherDay.h"

@implementation DVSTenDayWeatherDay

+(instancetype)createDVSTenDayWeatherDayFromDictionary:(NSDictionary *)dictionary {
    
    DVSTenDayWeatherDay *finalDay = [[DVSTenDayWeatherDay alloc]init];
    
    finalDay.highTemp = [dictionary[@"high"][@"fahrenheit"]floatValue];
    finalDay.lowTemp = [dictionary[@"low"][@"fahrenheit"]floatValue];
    finalDay.condition = dictionary[@"conditions"];
    finalDay.icon = nil;
    finalDay.weekday = dictionary[@"date"][@"weekday"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.day = [dictionary[@"date"][@"day"]integerValue];
    dateComponents.month = [dictionary[@"date"][@"month"]integerValue];
    dateComponents.year = [dictionary[@"date"][@"year"] integerValue];
    
    finalDay.date = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    
    return finalDay;
}


@end
