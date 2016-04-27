//
//  DVSCurrentDay.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DVSCurrentDay : NSObject

@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSString *highTemp;
@property (nonatomic, strong)NSString *lowTemp;
@property (nonatomic, strong)UIImageView *dayIcon;
@property (nonatomic, strong)NSString *dayCondition;

+(instancetype)createDVSCurrentDayFromDictionary:(NSDictionary *)dictionary;

@end
