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
    
    [self createTheCentralCircle];
    
    
    [self createDirectionTriangle];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(guideUserToStageWithCompassAnimation) userInfo:nil repeats:YES];
    
//    [self performSelector:@selector(rotateDirectionTriangle) withObject:nil afterDelay:3];
    
    // Do any additional setup after loading the view.
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



-(void)createTheCentralCircle
{
    int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 5;
    
    // Add to parent layer
    [self.view.layer addSublayer:circle];
}



-(void)createDirectionTriangle
{

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -10, 175);
    CGPathAddLineToPoint(path, NULL, 190, 75);
    CGPathAddLineToPoint(path, NULL, 190, 275);
    CGPathAddLineToPoint(path, NULL, -10, 175);
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    [shapeLayer setBounds:CGRectMake(0, 0, 50, 200)];
    [shapeLayer setFillColor:[[UIColor blackColor]CGColor]];
    [shapeLayer setPosition:CGPointMake(200, 200)];
    [shapeLayer setPath:path];
    
    self.triangleShape = shapeLayer;
    
    [[[self view]layer]addSublayer:self.triangleShape];
    
}


-(void)guideUserToStageWithCompassAnimation
{
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotate.toValue = [NSNumber numberWithFloat:((190*M_PI)/ -180)];
    rotate.duration = 1.0;

    if ([self.hotStage  isEqual: @"Rock"]){
        NSLog(@"animate the compas for the hot stage ROCK");
        
        CATransform3D rotationTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        rotate.toValue = [NSValue valueWithCATransform3D:rotationTransform];
        rotate.duration = 1.0f;
        rotate.cumulative = YES;
        rotate.repeatCount = HUGE_VALF;
    
        
    } else if ([self.hotStage  isEqual: @"Hip-hop"]) {
        NSLog(@"animate the compass for the hot stage of Hip-HOP");

    }
    
    [self.triangleShape addAnimation:rotate forKey:@"rotation"];

    
}




-(void)pointCompassWest
{
    
    
}


-(void)pointCompassEast
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)moveButtonPressed:(id)sender {
//    
//    [self rotateDirectionTriangle];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
