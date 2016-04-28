//
//  ViewController.m
//  wethar
//
//  Created by Dylan Straughan on 4/25/16.
//  Copyright © 2016 Dylan Straughan. All rights reserved.
//

#import "ViewController.h"
#import "flickrAPIClient.h"
#import <UIImageView+AFNetworking.h>
#import "DVSDatastore.h"
#import "DVSMainView.h"
#import "DVSNextView.h"
  
@interface ViewController () <DVSMainViewDelegate>

@property (nonatomic, strong) DVSDatastore *sharedDatastore;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *flickrImage;
@property (strong, nonatomic) IBOutlet DVSMainView *mainView;
@property (strong, nonatomic) IBOutlet DVSNextView *nextView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blurViewCenterYON;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blurViewCenterYOFF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedDatastore = [DVSDatastore sharedDatastore];
    
    [self.sharedDatastore getLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithWeatherDataFromCurrentLocationNotification:) name:@"locationInfoComplete" object:nil];
    
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    self.blurViewCenterYOFF.constant = -self.view.frame.size.height;
    self.blurViewCenterYON.active = NO;
    self.blurViewCenterYOFF.active = YES;
}

// SET UP VIEWS

- (void)updateLabelsWithWeatherDataFromCurrentLocationNotification:(NSNotification *)notification{
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",self.sharedDatastore.city,self.sharedDatastore.state];
    
    [self setImageView];
    
    [self.sharedDatastore getHourlyForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
//                NSLog(@"hourlyWeatherForecast: %@", self.sharedDatastore.hourlyWeatherForecast);
                self.mainView.hourlyForecast = self.sharedDatastore.hourlyWeatherForecast;
                
            }];
        }
        
    }];
    
    [self.sharedDatastore getTenDayForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
//                NSLog(@"tenDayWeatherForecast: %@", self.sharedDatastore.tenDayWeatherForecast);
                
                self.nextView.arrayOfDays = self.sharedDatastore.tenDayWeatherForecast;

            }];
        }

        
    }];
    
    [self.sharedDatastore getCurrentDayForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
//                NSLog(@"currentDayWeatherForecast: %@", self.sharedDatastore.currentDay);
                self.mainView.currentDayForecast = self.sharedDatastore.currentDay;
                
            }];
        }

    }];
    
    [self.sharedDatastore getCurrentConditionsForcastWithCompletion:^(BOOL isComplete) {
       
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.mainView.currentForecast = self.sharedDatastore.currentConditions;
                                
            }];
        }
        
    }];
    
}

-(void)setImageView{
    
    flickrAPIClient *APIClient = [[flickrAPIClient alloc]init];
    
    [APIClient  getPhotoFromFlickrWithLatitude:self.sharedDatastore.latitude longitude:self.sharedDatastore.longitude city:self.sharedDatastore.urlCity state:self.sharedDatastore.state andCompletionBlock:^(NSURL *image){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.flickrImage setImageWithURL:image];
                        
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)longPressIsOccuring:(BOOL)ocurring {
    
    if (ocurring) {
        
        [UIView animateWithDuration:.05 animations:^{
           
            self.blurViewCenterYON.active = YES;
            self.blurViewCenterYOFF.active = NO;
            
            [self.view layoutIfNeeded];
            
        }];
        
        
    } else {
        
        [UIView animateWithDuration:.05 animations:^{
            
            self.blurViewCenterYON.active = NO;
            self.blurViewCenterYOFF.active = YES;
            
            [self.view layoutIfNeeded];
            
        }];
        
    }
    
}


@end
