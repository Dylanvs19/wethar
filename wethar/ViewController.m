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

@interface ViewController ()

@property (nonatomic, strong) DVSDatastore *sharedDatastore;
@property (strong, nonatomic) IBOutlet UILabel *TempLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *flickrImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedDatastore = [DVSDatastore sharedDatastore];
    
    [self.sharedDatastore getLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithWeatherDataFromCurrentLocationNotification:) name:@"locationInfoComplete" object:nil];
    
}

// SET UP VIEWS

- (void)updateLabelsWithWeatherDataFromCurrentLocationNotification:(NSNotification *)notification{
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",self.sharedDatastore.city,self.sharedDatastore.state];
    
    [self setImageView];
    
    [self.sharedDatastore getHourlyForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                
            }];
        }
        
    }];
    
    [self.sharedDatastore getTenDayForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
            }];
        }

        
    }];
    
    [self.sharedDatastore getCurrentDayForcastWithCompletion:^(BOOL isComplete) {
        
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
               
                
            }];
        }

    }];
    
    [self.sharedDatastore getCurrentConditionsForcastWithCompletion:^(BOOL isComplete) {
       
        if(isComplete) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.TempLabel.text = [NSString stringWithFormat:@"%.1f",self.sharedDatastore.currentConditions.currentTemp ];
                                
            }];
        }
        
    }];
    
    
}

-(void)setImageView{
    
    flickrAPIClient *APIClient = [[flickrAPIClient alloc]init];
    
    [APIClient  getPhotoFromFlickrWithLatitude:self.sharedDatastore.latitude longitude:self.sharedDatastore.longitude city:self.sharedDatastore.urlCity state:self.sharedDatastore.state andCompletionBlock:^(NSURL *image){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.flickrImage setImageWithURL:image];
            
            NSLog(@"%@",self.flickrImage);
            
        }];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
