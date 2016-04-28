//
//  DVSTenDayWeatherDay.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DVSTenDayWeatherDay : NSObject

@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)NSString *condition;
@property (nonatomic) CGFloat highTemp;
@property (nonatomic) CGFloat lowTemp;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSString *weekday;

+(instancetype)createDVSTenDayWeatherDayFromDictionary:(NSDictionary *)dictionary;

@end
