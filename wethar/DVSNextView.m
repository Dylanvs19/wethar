//
//  DVSNextView.m
//  wethar
//
//  Created by Dylan Straughan on 4/27/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSNextView.h"
#import "DVSTenDayWeatherForcast.h"
#import "DVSTenDayWeatherDay.h"

@interface DVSNextView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayOne;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayTwo;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayThree;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayFour;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayFive;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *daySix;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *daySeven;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayEight;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayNine;
@property (strong, nonatomic) IBOutlet DVSTenDayWeatherForcast *dayTen;

@end

@implementation DVSNextView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"DVSNextView" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
}

-(void)setArrayOfDays:(NSArray *)arrayOfDays {
    
    _arrayOfDays = arrayOfDays;
    
    
    [self setupDays];
}

-(void)setupDays{
    
    self.dayOne.day = self.arrayOfDays[0];
    self.dayTwo.day = self.arrayOfDays[1];
    self.dayThree.day = self.arrayOfDays[2];
    self.dayFour.day = self.arrayOfDays[3];
    self.dayFive.day = self.arrayOfDays[4];
    self.daySix.day = self.arrayOfDays[5];
    self.daySeven.day = self.arrayOfDays[6];
    self.dayEight.day = self.arrayOfDays[7];
    self.dayNine.day = self.arrayOfDays[8];
    self.dayTen.day = self.arrayOfDays[9];
    
}





@end
