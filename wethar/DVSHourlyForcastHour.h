//
//  hourlyForcastHour.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DVSHourlyForcastHour : NSObject

@property (nonatomic, strong)NSString *temp;
@property (nonatomic, strong)UIImageView *hourIcon;
@property (nonatomic, strong)NSString *hour;
@property (nonatomic, strong)NSString *conditions;


+(instancetype)createDVSHourlyForcastHourFromDictionary:(NSDictionary *)dictionary;


@end
