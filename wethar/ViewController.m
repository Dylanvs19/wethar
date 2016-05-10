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
  
@interface ViewController () <DVSMainViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (strong, nonatomic) IBOutlet UIView *indicatorView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerXInside;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerXOutSide;
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
    self.blurViewCenterYOFF.active = NO;
    self.blurViewCenterYON.active = YES;
    self.blurView.alpha = 0;
    
    self.mainView.delegate = self;
    self.scrollView.delegate = self;
    
    self.shouldChangeImage = YES;
    self.centerXInside.constant = self.view.frame.size.width;
    self.centerXInside.active = YES;
    self.centerXOutSide.active = NO;
    self.indicatorView.alpha = 0.0;
    self.indicatorLabel.alpha = 0.0;

    
    UIScreenEdgePanGestureRecognizer *panleft = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panDidPan:)];
    panleft.edges = UIRectEdgeLeft;

    panleft.delegate = self;
    
    [self.view addGestureRecognizer:panleft];
    
    UIScreenEdgePanGestureRecognizer *panRight = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panDidPan:)];
    panRight.edges = UIRectEdgeRight;
    
    panRight.delegate = self;
    
    [self.view addGestureRecognizer:panRight];
    
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
    
    
}

//SCROLLVIEWDELEGATE

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.flickrImageCenterX.constant = scrollView.contentOffset.y/20;
    
    if (scrollView.contentOffset.y < -self.view.frame.size.height/5 && self.shouldChangeImage) {
        
        [self setImageView];
        
        self.shouldChangeImage = NO;
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.shouldChangeImage = YES;

}

// UIGESTUREDELEGATE

-(void)panDidPan:(UIGestureRecognizer*)pan {
    
    CGPoint locationInView = [pan locationInView:self.view];
    
    self.centerXInside.active = NO;
    self.centerXOutSide.constant =(locationInView.x - self.view.frame.size.width/2);
    self.centerXOutSide.active = YES;
    self.indicatorLabel.text = [NSString stringWithFormat:@"%f", locationInView.x];
    
    
    if(pan.state == UIGestureRecognizerStateBegan) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.blurView.alpha = 1;

                [self.view layoutIfNeeded];
                
            }];
        
        [UIView animateWithDuration:.5 delay:0.5 options:0 animations:^{
            
            self.indicatorView.alpha = 1;
            self.indicatorLabel.alpha = 1;
            
            
            CGMutablePathRef tempLine = CGPathCreateMutable();
            CGPathMoveToPoint(tempLine, nil, self.view.frame.origin.x, self.view.frame.origin.y);
            CGPathAddQuadCurveToPoint(tempLine, nil, 30, 129, 77, 157);
            CGPathAddCurveToPoint(tempLine, nil, 190, 210, 200, 70, 303, 125);
            
            UIBezierPath *mybezierpath = [UIBezierPath
                                          bezierPathWithCGPath:tempLine];
            
            CAShapeLayer *lines = [CAShapeLayer layer];
            lines.path = mybezierpath.CGPath;
            lines.bounds = CGPathGetBoundingBox(lines.path);
            lines.strokeColor = [UIColor whiteColor].CGColor;
            lines.fillColor = [UIColor clearColor].CGColor; /*if you just want lines*/
            lines.lineWidth = 3;
            lines.position = CGPointMake(self.blurView.contentView.frame.size.width/2.0, self.blurView.contentView.frame.size.height/2.0);
            lines.anchorPoint = CGPointMake(.5, .5);
            
            [self.blurView.contentView.layer addSublayer:lines];
            
            [self.view layoutIfNeeded];
            
            
        } completion:nil];
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded){
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.blurView.alpha = 0;
                    self.indicatorView.alpha = 0.0;
                    self.indicatorLabel.alpha = 0.0;
                    
                    [self.view layoutIfNeeded];
                    
            }];
    }
    
}

-(void)drawBezierPathInRect:(CGRect)rect inContext:(CGContextRef)context wtihColorSpace:(CGColorSpaceRef)colorSpace{
    
    CGMutablePathRef tempLine = CGPathCreateMutable();
    CGPathMoveToPoint(tempLine, nil, -5, 157);
    CGPathAddQuadCurveToPoint(tempLine, nil, 30, 129, 77, 157);
    CGPathAddCurveToPoint(tempLine, nil, 190, 210, 200, 70, 303, 125);


    CGPathRelease(tempLine);
    CGContextRestoreGState(context);
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    [self drawBezierPathInRect:rect inContext:context wtihColorSpace:colorSpace];
    
    CGColorSpaceRelease(colorSpace);
}


@end
