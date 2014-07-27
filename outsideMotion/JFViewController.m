//
//  JFViewController.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/26/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface JFViewController ()


@property (weak, nonatomic) IBOutlet UIView *recordingIndication;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *allX;
@property (strong, nonatomic) NSMutableArray *allY;
@property (strong, nonatomic) NSMutableArray *allZ;
@property double averageOfXValues;
@property double averageOfYValues;
@property double averageOfZValues;
@property double averageOfAllGyroValues;
@property BOOL isAnalyzing;

@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isAnalyzing = NO;

    self.allX = [[NSMutableArray alloc]init];
    self.allY = [[NSMutableArray alloc]init];
    self.allZ = [[NSMutableArray alloc]init];
    
    self.motionManager = [[CMMotionManager alloc]init];
    
    self.recordingIndication.backgroundColor = [UIColor redColor];
    
//    if (self.isAnalyzing){
//        self.recordingIndication.backgroundColor = [UIColor greenColor];
//    } else {
//        self.recordingIndication.backgroundColor = [UIColor redColor];
//    }
    
}

- (IBAction)startRecordingPressed:(id)sender {
    
    [self performSelector:@selector(analyzeUserMotion) withObject:nil afterDelay:2];
    
}



-(void)analyzeUserMotion
{
    
//    self.isAnalyzing = YES;
    self.recordingIndication.backgroundColor = [UIColor greenColor];
    
    if ([self.motionManager isGyroAvailable])
    {
        
        [self.motionManager setGyroUpdateInterval:1.0f / 2.0f];
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
            [self.allX addObject:x];
            
            NSString *y = [[NSString alloc]initWithFormat:@"%.02f", gyroData.rotationRate.y];
            [self.allY addObject:y];
            
            NSString *z = [[NSString alloc]initWithFormat:@"%.02f", gyroData.rotationRate.z];
            [self.allZ addObject:z];
            
        }];
        
        [self performSelector:@selector(stopRecordingPressed:) withObject:nil afterDelay:20];
        
    }
    
}


- (IBAction)stopRecordingPressed:(id)sender {
    
    [self.motionManager stopGyroUpdates];
    
    [self createAverageOfXValues];
    
    [self createAverageOfYValues];
    
    [self createAverageOfZValues];
    
    [self averageAllGyroAverages];
    
}

-(void)createAverageOfXValues
{
    
    double arrayCount = [self.allX count];
    
    double sumOfAllXValues;

    
    for (NSString *x in self.allX){
        
        double xdouble = [x doubleValue];
        
        sumOfAllXValues += xdouble;

    }
    
    self.averageOfXValues = sumOfAllXValues / arrayCount;

    NSLog(@"the x values are %@", self.allX);
    
//    NSLog(@"the sum of all the x values is %f", sumOfAllXValues);
    
    NSLog(@"the average of all the x values is %f", self.averageOfXValues);
    
    
}

-(void)createAverageOfYValues
{
    
    double arrayCount = [self.allY count];
    
    double sumOfAllYValues;
    
    
    for (NSString *y in self.allY){
        
        double ydouble = [y doubleValue];
        
        sumOfAllYValues += ydouble;
        
    }
    
    self.averageOfYValues = sumOfAllYValues / arrayCount;
    
    NSLog(@"the y values are %@", self.allY);
    
//    NSLog(@"the sum of all the y values is %f", sumOfAllYValues);
    
    NSLog(@"the average of all the y values is %f", self.averageOfYValues);
    
}

-(void)createAverageOfZValues
{
    
    double arrayCount = [self.allZ count];
    
    double sumOfAllZValues;
    
    for (NSString *z in self.allZ){
        double zDouble = [z doubleValue];
        
        sumOfAllZValues += zDouble;
    }
    
    self.averageOfZValues = sumOfAllZValues / arrayCount;
    
    NSLog(@"the z values are %@", self.allZ);
//    NSLog(@"the sum of all the z values is %f", sumOfAllZValues);
    NSLog(@"the average of all the z values is %f", self.averageOfZValues);
    
}


-(void)averageAllGyroAverages
{
    
    double addedGyroValues = self.averageOfXValues + self.averageOfYValues + self.averageOfZValues;
    
    self.averageOfAllGyroValues = addedGyroValues / 3;
    
    NSLog(@"the average of ALL Gyro values is %f", self.averageOfAllGyroValues);

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
