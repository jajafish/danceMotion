//
//  JFDanceCompassVC.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/26/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceCompassVC.h"

@interface JFDanceCompassVC ()

@property (strong, nonatomic) CALayer *triangleShape;

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
    
    [self createTheCentralCircle];
    
//    [self createTheCompassPointer];
    
    [self createDirectionTriangle];
    
    [self performSelector:@selector(rotateDirectionTriangle) withObject:nil afterDelay:3];
    
    // Do any additional setup after loading the view.
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

-(void)createTheCompassPointer
{

    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor grayColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.frame = CGRectMake(self.view.center.x-8, self.view.center.y-96, 20, 192);
    sublayer.borderColor = [UIColor blackColor].CGColor;
    sublayer.borderWidth = 2.0;
    sublayer.cornerRadius = 10.0;
    

    
    [self.view.layer addSublayer:sublayer];
    
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


-(void)rotateDirectionTriangle
{
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(40, 20)];
    anim.duration = 2.0;
    
    [self.triangleShape addAnimation:anim forKey:@"anim"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveButtonPressed:(id)sender {
    
    [self rotateDirectionTriangle];
}

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
