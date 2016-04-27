//
//  DVSDatastore.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "flickrAPIClient.h"
#import "wundergroundAPIClient.h"
#import "DVSTenDayWeatherDay.h"
#import "DVSCurrentDay.h"
#import "DVSHourlyForcastHour.h"
#import "DVSCurrentForecast.h"
#import "secrets.h"

@interface DVSDatastore : NSObject

@property (nonatomic, strong)NSMutableArray *tenDayWeatherForecast;
@property (nonatomic, strong)NSArray *hourlyWeatherForecast;
@property (nonatomic, strong)DVSCurrentDay *currentDay;
@property (nonatomic, strong)DVSCurrentForecast *currentConditions;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *urlCity;
@property (nonatomic, strong) NSDate *currentDate;


+ (instancetype)sharedDatastore;

-(void)getTenDayForcastWithCompletion:(void(^)(BOOL))completionBlock;

-(void)getCurrentDayForcastWithCompletion:(void(^)(BOOL))completionBlock;

-(void)getHourlyForcastWithCompletion:(void(^)(BOOL))completionBlock;

-(void)getCurrentConditionsForcastWithCompletion:(void(^)(BOOL))completionBlock;

-(void)getLocation;

@end
