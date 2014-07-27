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

@property (strong, nonatomic) IBOutlet UIImageView *compassImageView;
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
    

    
    
    self.compassImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 140, 240, 240)];
    self.compassImageView.backgroundColor = [UIColor greenColor];
    UIImage *img = [UIImage imageNamed:@"tree.jpg"];
    self.compassImageView.image = img;
    

    CGRect frameOfCompassImageView = self.compassImageView.frame;
    NSLog(@"the frame of the compass image view is %@", NSStringFromCGRect(frameOfCompassImageView));
    
    

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
    
    NSLog(@"the hot stage is %@", self.hotStage);
    
}


- (IBAction)rotateTheImage:(UIButton *)sender {
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    anim.fromValue = [NSValue valueWithCATransform3D:self.compassImageView.layer.transform];
//    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0)];
//    anim.duration = 1.0;
//    anim.repeatCount = CGFLOAT_MAX;
//    anim.autoreverses = YES;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.compassImageView.layer addAnimation:anim forKey:@"xform"];
//    [self.view setNeedsDisplay];
    
    NSLog(@"the compass SHOULD move");
    
    CALayer *layer = self.compassImageView.layer;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, 0.0)];
    anim.duration = 2.0;
    [layer addAnimation:anim forKey:@"anim"];

    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
