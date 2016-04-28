//
//  DVSTenDayWeatherForcast.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSTenDayWeatherForcast.h"

@interface DVSTenDayWeatherForcast ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *highTempLabel;

@end

@implementation DVSTenDayWeatherForcast


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
 
    [[NSBundle mainBundle] loadNibNamed:@"DVSTenDayWeatherForcast" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
}

-(void)setDay:(DVSTenDayWeatherDay *)day{
    
    _day = day;
    
    [self setupDay];
    
}

-(void)setupDay {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEE, MMM d"];
    
    self.dayLabel.text = [dateFormatter stringFromDate:self.day.date];
    self.highTempLabel.text = [NSString stringWithFormat:@"%li°",(NSInteger)self.day.highTemp];
    self.lowTempLabel.text = [NSString stringWithFormat:@"%li°",(NSInteger)self.day.lowTemp];

}



@end
