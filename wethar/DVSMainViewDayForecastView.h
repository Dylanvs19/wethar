//
//  MainViewDayForecastView.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVSCurrentDay.h"
#import "DVSCurrentForecast.h"

@interface DVSMainViewDayForecastView : UIView

@property (nonatomic, strong)DVSCurrentDay *dayForecast;
@property (nonatomic, strong)DVSCurrentForecast *currentForecast;

@end
