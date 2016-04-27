//
//  DVSCurrentForecast.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DVSCurrentForecast : NSObject

@property (nonatomic) CGFloat currentTemp;
@property (nonatomic, strong)UIImageView *currentIcon;
@property (nonatomic, strong)NSString *currentCondition;
@property (nonatomic) CGFloat currentHumidity;
@property (nonatomic) CGFloat currentWindSpeed;
@property (nonatomic, strong) NSString *currentWindSpeedDirection;
@property (nonatomic) CGFloat feelsLikeTemp;

+(instancetype)createDVSCurrentForecastFromDictionary:(NSDictionary *)dictionary;

@end
