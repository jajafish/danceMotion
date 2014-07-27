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
@property BOOL isAnalyzing;

// gyro
@property (strong, nonatomic) NSMutableArray *allGyroX;
@property (strong, nonatomic) NSMutableArray *allGyroY;
@property (strong, nonatomic) NSMutableArray *allGyroZ;
@property double averageOfGyroXValues;
@property double averageOfGyroYValues;
@property double averageOfGyroZValues;
@property double averageOfAllGyroValues;

// accell
@property (strong, nonatomic) NSMutableArray *allAccelX;
@property (strong, nonatomic) NSMutableArray *allAccelY;
@property (strong, nonatomic) NSMutableArray *allAccelZ;
@property double averageOfAccelXValues;
@property double averageOfAccelYValues;
@property double averageOfAccelZValues;
@property double averageOfAllAccelValues;

@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isAnalyzing = NO;

    self.allGyroX = [[NSMutableArray alloc]init];
    self.allGyroY = [[NSMutableArray alloc]init];
    self.allGyroZ = [[NSMutableArray alloc]init];
    
    self.allAccelX = [[NSMutableArray alloc]init];
    self.allAccelY = [[NSMutableArray alloc]init];
    self.allAccelZ = [[NSMutableArray alloc]init];
    
    self.motionManager = [[CMMotionManager alloc]init];
    
    self.recordingIndication.backgroundColor = [UIColor redColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRecordingPressed:(id)sender {
    
    [self performSelector:@selector(analyzeUserMotion) withObject:nil afterDelay:2];
    
}


// MOTION RECORDING

-(void)analyzeUserMotion
{
    
    self.recordingIndication.backgroundColor = [UIColor greenColor];
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        [self.motionManager setAccelerometerUpdateInterval:1.0f / 1.0f];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            NSString *accelX = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.x];
            [self.allAccelX addObject:accelX];
            
            NSString *accelY = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.y];
            [self.allAccelY addObject:accelY];
            
            NSString *accelZ = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.z];
            [self.allAccelZ addObject:accelZ];
            
            [self calculateAndSendNormOfMotionActivity:(NSString *)accelX :(NSString *)accelY :(NSString *)accelZ];
        
        }];
        
    }
    
    
    
    
//    [self performSelector:@selector(stopRecordingPressed:) withObject:nil afterDelay:1];
    
}


- (IBAction)stopRecordingPressed:(id)sender {
    
    [self.motionManager stopGyroUpdates];
    

    
    // ACCEL
    [self createAverageOfAccelXValues];
    [self createAverageOfAccelYValues];
    [self createAverageOfAccelZValues];
    [self averageAllAccelAverages];
    
    
}




// ACCEL ANALYSIS


-(void)createAverageOfAccelXValues
{
    
    double arrayCount = [self.allAccelX count];
    
    double sumOfAllXValues;
    
    
    for (NSString *x in self.allAccelX){
        
        double xdouble = [x doubleValue];
        
        sumOfAllXValues += xdouble;
        
    }
    
    self.averageOfAccelXValues = sumOfAllXValues / arrayCount;
    
    NSLog(@"the ACCEL x values are %@", self.allAccelX);
    
    //    NSLog(@"the sum of all the x values is %f", sumOfAllXValues);
    
    NSLog(@"the average of all the ACCEL x values is %f", self.averageOfAccelXValues);
    
}


-(void)createAverageOfAccelYValues
{
    
    double arrayCount = [self.allAccelY count];
    
    double sumOfAllYValues;
    
    
    for (NSString *y in self.allAccelY){
        
        double ydouble = [y doubleValue];
        
        sumOfAllYValues += ydouble;
        
    }
    
    self.averageOfAccelYValues = sumOfAllYValues / arrayCount;
    
    NSLog(@"the ACCEL Y values are %@", self.allAccelY);
    
    //    NSLog(@"the sum of all the y values is %f", sumOfAllYValues);
    
    NSLog(@"the average of all the ACCEL y values is %f", self.averageOfAccelYValues);
    
}



-(void)createAverageOfAccelZValues
{
    
    double arrayCount = [self.allAccelZ count];
    
    double sumOfAllZValues;
    
    for (NSString *z in self.allAccelZ){
        double zDouble = [z doubleValue];
        
        sumOfAllZValues += zDouble;
    }
    
    self.averageOfAccelZValues = sumOfAllZValues / arrayCount;
    
    NSLog(@"the ACCEL z values are %@", self.allAccelZ);
    //    NSLog(@"the sum of all the z values is %f", sumOfAllZValues);
    NSLog(@"the average of all the z ACCEL values is %f", self.averageOfAccelZValues);
    
}


-(void)averageAllAccelAverages
{
    
    double addedAccelValues = self.averageOfAccelXValues + self.averageOfAccelYValues + self.averageOfAccelZValues;
    
    self.averageOfAllAccelValues = addedAccelValues / 3;
    
    NSLog(@"the average of ALL ACCEL values is %f", self.averageOfAllAccelValues);
    
}



-(void)calculateAndSendNormOfMotionActivity:(NSString *)accelXValue :(NSString *)accelYValue :(NSString *)accelZValue
{

    double x = [accelXValue doubleValue];
    double y = [accelYValue doubleValue];
    double z = [accelZValue doubleValue];
    
    double x2 = pow(x, 2);
    double y2 = pow(y, 2);
    double z2 = pow(z, 2);
    
    double combOfSq = (x2 + y2 + z2);
    
    double rootOfComb = sqrt(combOfSq);
    
    NSLog(@"the root of the comb is %f", rootOfComb);
    
}

-(void)calculateNormOfMotionValues
{
    
    
    double result = pow(3, 2);
    NSLog(@"%f", result);

    
    
}



- (IBAction)normPressed:(id)sender {
    
    [self calculateNormOfMotionValues];
}






@end
