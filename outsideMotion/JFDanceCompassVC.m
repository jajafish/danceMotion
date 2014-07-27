//
//  JFDanceCompassVC.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/26/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceCompassVC.h"
#import <CoreLocation/CoreLocation.h>


typedef enum stages {west, east}Direction;

@interface JFDanceCompassVC () <CLLocationManagerDelegate>

// UI Elements
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *danceCompassLogo;
@property (strong, nonatomic) UIImageView *backgroundSafariBrand;
@property (strong, nonatomic) IBOutlet UISegmentedControl *hotStageSegment;
@property (strong, nonatomic) NSString *hotStage;

// Compass properties
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation JFDanceCompassVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up the background view
    UIImage *backgroundView = [UIImage imageNamed:@"dcbg.png"];
    self.backgroundSafariBrand = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 517)];
    self.backgroundSafariBrand.image = backgroundView;
    [self.view insertSubview:self.backgroundSafariBrand belowSubview:self.subView];
    
    
    // set up the segmenet control for genres
    self.hotStageSegment = [[UISegmentedControl alloc]init];
    [self.view addSubview:self.hotStageSegment];
    self.hotStageSegment.frame = CGRectMake(5, 450, 100, 40);
    [self.hotStageSegment insertSegmentWithTitle:@"rock" atIndex:0 animated:YES];
    [self.hotStageSegment insertSegmentWithTitle:@"hip-hop" atIndex:1 animated:YES];
    [self.hotStageSegment addTarget:self action:@selector(hotStageIs:) forControlEvents:UIControlEventValueChanged];
    
    
    // set up the spinning wheel
    _subView.layer.contents = (id)[UIImage imageNamed:@"transTri.png"].CGImage;
    [_subView.layer setOpaque:NO];
    _subView.opaque = NO;
    
    
    // set up the location manager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];


}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    NSLog(@"COMPASS DATA");
    NSLog(@"%@", [NSString stringWithFormat:@"%f", newHeading.magneticHeading]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", newHeading.trueHeading]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude]);
    
    
}


- (IBAction)hotStageIs:(UISegmentedControl *)sender {
    
    switch (self.hotStageSegment.selectedSegmentIndex) {
        case 0:
            self.hotStage = @"Rock";
            break;
        case 1:
            self.hotStage = @"Hip-hop";
            break;
        default:
            break;
    }
    
    [self pointTheCompass];
    
    NSLog(@"the hot stage is %@", self.hotStage);
    
}


-(void)pointTheCompass
{
    
    CALayer *layer = _subView.layer;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    if ([self.hotStage isEqualToString:@"Rock"]){
        NSLog(@"the hot stage is rock (from if)");
        
        anim.fromValue = [NSValue valueWithCATransform3D:layer.transform];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
        anim.duration = 1.0;
        anim.repeatCount = CGFLOAT_MAX;
        anim.autoreverses = YES;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        
    } else if ([self.hotStage isEqualToString:@"Hip-hop"]){
        
        anim.fromValue = [NSValue valueWithCATransform3D:layer.transform];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, -1.0)];
        anim.duration = 1.0;
        anim.repeatCount = CGFLOAT_MAX;
        anim.autoreverses = YES;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
    }
    
    [layer addAnimation:anim forKey:@"xform"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
