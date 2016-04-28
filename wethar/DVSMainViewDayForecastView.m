//
//  MainViewDayForecastView.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSMainViewDayForecastView.h"
#import "DVSDatastore.h"

@interface DVSMainViewDayForecastView  ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *dayConditionIcon;
@property (strong, nonatomic) IBOutlet UILabel *highTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentConditionLabel;
@property (nonatomic, strong) DVSDatastore *sharedDatastore;


@end

@implementation DVSMainViewDayForecastView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
    }
    
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit{
    
    [[NSBundle mainBundle] loadNibNamed:@"DVSMainViewDayForecastView" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
}

-(void)setCurrentForecast:(DVSCurrentForecast *)currentForecast {
    
    _currentForecast = currentForecast;
    
    //this is just for the current icon. 
    
}

-(void)setDayForecast:(DVSCurrentDay *)dayForecast {
    
    _dayForecast = dayForecast;
    
    self.highTempLabel.text = [NSString stringWithFormat:@"%li°",(NSInteger)self.dayForecast.highTemp];
    self.lowTempLabel.text = [NSString stringWithFormat:@"%li°",(NSInteger)self.dayForecast.lowTemp];

    
}






@end
