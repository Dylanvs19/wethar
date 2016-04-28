//
//  DVSMainView.h
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVSCurrentForecast.h"
#import "DVSCurrentDay.h"

@class DVSMainView;

@protocol DVSMainViewDelegate <NSObject>



@optional

-(void)longPressIsOccuring:(BOOL)ocurring;

@end

@interface DVSMainView : UIView
@property (nonatomic, weak) id<DVSMainViewDelegate> delegate;
@property (nonatomic, strong)DVSCurrentForecast *currentForecast;
@property (nonatomic, strong)NSArray *hourlyForecast;
@property (nonatomic, strong)DVSCurrentDay *currentDayForecast;

@end
