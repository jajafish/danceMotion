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
    

    
    
//    self.compassImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 140, 240, 240)];
//    self.compassImageView.backgroundColor = [UIColor greenColor];
//    UIImage *img = [UIImage imageNamed:@"tree.jpg"];
//    self.compassImageView.image = img;
//    
//
//    CGRect frameOfCompassImageView = self.compassImageView.frame;
//    NSLog(@"the frame of the compass image view is %@", NSStringFromCGRect(frameOfCompassImageView));
    
    

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


    CALayer *layer = _subView.layer;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 1000.0;
    layer.transform = perspective;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D curlXform = layer.transform;
    CATransform3D rotXform = CATransform3DRotate(curlXform, M_PI_2, 0.0, 1.0, 0.0);
    
    CATransform3D rotAndMoveLeft = CATransform3DTranslate(rotXform, 0.0, 0.0, -100.0);
    CATransform3D rotAndMoveRight = CATransform3DTranslate(rotXform, 0.0, 0.0, 100.0);
    
    anim.values = @[
                    [NSValue valueWithCATransform3D:curlXform],
                    [NSValue valueWithCATransform3D:rotXform],
                    [NSValue valueWithCATransform3D:rotAndMoveLeft],
                    [NSValue valueWithCATransform3D:rotAndMoveRight],
                    [NSValue valueWithCATransform3D:rotXform],
                    ];
    
    anim.duration = 2.0;
    anim.repeatCount = CGFLOAT_MAX;
    anim.autoreverses = NO;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:anim forKey:@"xform"];

    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
