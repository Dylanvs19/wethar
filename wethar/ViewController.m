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
  
@interface ViewController () <DVSMainViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DVSDatastore *sharedDatastore;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *flickrImage;
@property (strong, nonatomic) IBOutlet DVSMainView *mainView;
@property (strong, nonatomic) IBOutlet DVSNextView *nextView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blurViewCenterYON;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blurViewCenterYOFF;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *flickrImageCenterX;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL shouldChangeImage;

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
    self.mainView.delegate = self;
    self.scrollView.delegate = self;
    self.shouldChangeImage = YES;
}

// SET UP VIEWS

- (void)updateLabelsWithWeatherDataFromCurrentLocationNotification:(NSNotification *)notification{
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",self.sharedDatastore.city,self.sharedDatastore.state];
    
    [self setImageView];
    
    [self.sharedDatastore getWeatherForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.mainView.hourlyForecast = self.sharedDatastore.hourlyWeatherForecast;
                self.nextView.arrayOfDays = self.sharedDatastore.tenDayWeatherForecast;
                self.mainView.currentDayForecast = self.sharedDatastore.currentDay;
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

// DELEGATE METHOD FROM DVSMAINVEWDELEGATE

-(void)dvsMainViewCell:(DVSMainView *)mainView longPressIsOccuring:(BOOL)ocurring  {
    
    if (ocurring) {
        
        [UIView animateWithDuration:0.75 animations:^{
           
            self.blurViewCenterYON.active = YES;
            self.blurViewCenterYOFF.active = NO;
            
            [self.view layoutIfNeeded];
            
        }];
        
        
    } else {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.blurViewCenterYON.active = NO;
            self.blurViewCenterYOFF.active = YES;
            
            [self.view layoutIfNeeded];
            
        }];
        
    }
    
}

//SCROLLVIEWDELEGATE

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.flickrImageCenterX.constant = scrollView.contentOffset.y/20;
    
    if (scrollView.contentOffset.y < -self.view.frame.size.height/4 && self.shouldChangeImage) {
        
        [self setImageView];
        
        self.shouldChangeImage = NO;
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.shouldChangeImage = YES;

}


@end
