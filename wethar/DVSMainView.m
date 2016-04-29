//
//  DVSMainView.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSMainView.h"
#import "DVSMainViewDayForecastView.h"
#import "DVSDatastore.h"

@interface DVSMainView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (strong, nonatomic) IBOutlet DVSMainViewDayForecastView *mainViewForecastView;
@property (nonatomic, strong) DVSDatastore *sharedDatastore;

@end

@implementation DVSMainView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"DVSMainView" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGestureRecognizerPressed:)];
    [self.contentView addGestureRecognizer:longPressGestureRecognizer];
    
}

-(void)setHourlyForecast:(NSArray *)hourlyForecast {
    
    _hourlyForecast = hourlyForecast;
    
    
}

-(void)setCurrentForecast:(DVSCurrentForecast *)currentForecast {
    
    _currentForecast = currentForecast;
    
    self.currentTempLabel.text = [NSString stringWithFormat:@"%li°",(NSInteger)self.currentForecast.currentTemp];
    self.mainViewForecastView.currentForecast = self.currentForecast;
    
}

-(void)setCurrentDayForecast:(DVSCurrentDay *)currentDayForecast {
    
    _currentDayForecast = currentDayForecast;
    
    self.mainViewForecastView.dayForecast = self.currentDayForecast;
    
}

-(void)longpressGestureRecognizerPressed:(UILongPressGestureRecognizer*)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        [self.delegate dvsMainViewCell:self longPressIsOccuring:YES];
        
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        
        [self.delegate dvsMainViewCell:self longPressIsOccuring:NO];

    }
    
}

@end
