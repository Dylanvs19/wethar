//
//  wundergroundAPIClient.h
//  wethar
//
//  Created by Dylan Straughan on 4/26/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wundergroundAPIClient : NSObject

+(void)fetchCurrentConditionsWeatherDataForLocationWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(NSDictionary*data))completionBlock;

+(void)fetchTenDayWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void(^)(NSArray*data))completionBlock;

+(void)fetchHourlyWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSArray *))completionBlock;

+(void)fetchCurrentDayWeatherForecastWithCity:(NSString *)city state:(NSString *)state andCompletionBlock:(void (^)(NSArray *))completionBlock;

@end
