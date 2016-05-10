//
//  DVSThirtySixHourView.m
//  wethar
//
//  Created by Dylan Straughan on 5/10/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "DVSThirtySixHourView.h"
#import "DVSHourlyForcastHour.h"

@interface DVSThirtySixHourView ()

@property (nonatomic, strong)NSMutableArray *bezierPathValues;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic)NSUInteger highTemp;
@property (nonatomic)NSUInteger lowTemp;

@end

@implementation DVSThirtySixHourView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"DVSThirtySixHourView" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
}


-(void)setThirtySixHourForecast:(NSArray *)thirtySixHourForecast {
    
    _thirtySixHourForecast = thirtySixHourForecast;
    
    [self setUpForecast];
    
}

-(void)setUpForecast {
    
    [self findHighTempFromArray:self.thirtySixHourForecast];
    [self findLowTempFromArray:self.thirtySixHourForecast];

    
    
    
//    CGMutablePathRef tempLine = CGPathCreateMutable();
//    CGPathMoveToPoint(tempLine, nil, self.contentView.frame.origin.x, self.contentView.frame.origin.y);
//    CGPathAddQuadCurveToPoint(tempLine, nil, 30, 129, 77, 157);
//    CGPathAddCurveToPoint(tempLine, nil, 190, 210, 200, 70, 303, 125);
//    
//    UIBezierPath *mybezierpath = [UIBezierPath
//                                  bezierPathWithCGPath:tempLine];
//    
//    CAShapeLayer *lines = [CAShapeLayer layer];
//    lines.path = mybezierpath.CGPath;
//    lines.bounds = CGPathGetBoundingBox(lines.path);
//    lines.strokeColor = [UIColor whiteColor].CGColor;
//    lines.fillColor = [UIColor clearColor].CGColor; /*if you just want lines*/
//    lines.lineWidth = 3;
//    lines.position = CGPointMake(self.contentView.frame.size.width/2.0, self.contentView.frame.size.height/2.0);
//    lines.anchorPoint = CGPointMake(.5, .5);
//    
//    [self.contentView.layer addSublayer:lines];
    
    
}

-(void)findHighTempFromArray:(NSArray *)array {
    
    for (DVSHourlyForcastHour *hour in array) {
        
        if (!self.highTemp){
            
            self.highTemp = hour.temp;
            
        } else if (self.highTemp < hour.temp){
            
            self.highTemp = hour.temp;
            
        }
        
    }
    
}

-(void)findLowTempFromArray:(NSArray *)array {
    
    for (DVSHourlyForcastHour *hour in array) {
        
        if (!self.lowTemp){
            
            self.lowTemp = hour.temp;
            
        } else if (self.lowTemp > hour.temp){
            
            self.lowTemp = hour.temp;
            
        }
        
    }
    
}
            

@end
