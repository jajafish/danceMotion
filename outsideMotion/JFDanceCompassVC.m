//
//  JFDanceCompassVC.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/26/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceCompassVC.h"

typedef enum stages {west, east}Direction;

@interface JFDanceCompassVC ()

@property (weak, nonatomic) IBOutlet UIView *subView;

@property (strong, nonatomic) IBOutlet UIView *danceCompassLogo;

@property (strong, nonatomic) IBOutlet UISegmentedControl *hotStageSegment;
@property (strong, nonatomic) CALayer *triangleShape;
@property (strong, nonatomic) NSString *hotStage;

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
    
    self.hotStageSegment = [[UISegmentedControl alloc]init];
    [self.view addSubview:self.hotStageSegment];
    self.hotStageSegment.frame = CGRectMake(5, 450, 100, 40);
    [self.hotStageSegment insertSegmentWithTitle:@"rock" atIndex:0 animated:YES];
    [self.hotStageSegment insertSegmentWithTitle:@"hip-hop" atIndex:1 animated:YES];
    [self.hotStageSegment addTarget:self action:@selector(hotStageIs:) forControlEvents:UIControlEventValueChanged];
    
    _subView.layer.contents = (id)[UIImage imageNamed:@"compass.png"].CGImage;
    

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
