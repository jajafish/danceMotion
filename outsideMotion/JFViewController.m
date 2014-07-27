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

@property (strong, nonatomic) UISegmentedControl *genreSegControl;
@property (weak, nonatomic) IBOutlet UIView *recordingIndication;
@property (strong, nonatomic) IBOutlet UIButton *stopRecordingButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingText;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property BOOL isAnalyzing;

@property (strong, nonatomic) NSString *genreStageAttending;

// ACCEL
@property (strong, nonatomic) NSString *accelX;
@property (strong, nonatomic) NSString *accelY;
@property (strong, nonatomic) NSString *accelZ;

@property (strong, nonatomic) NSString *accelOldX;
@property (strong, nonatomic) NSString *accelOldY;
@property (strong, nonatomic) NSString *accelOldZ;

// GYRO
@property (strong, nonatomic) NSString *gyroX;
@property (strong, nonatomic) NSString *gyroY;
@property (strong, nonatomic) NSString *gyroZ;


@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.genreSegControl = [[UISegmentedControl alloc]init];
    [self.view addSubview:self.genreSegControl];
    self.genreSegControl.frame = CGRectMake(10, 40, 300, 40);
    [self.genreSegControl insertSegmentWithTitle:@"rock" atIndex:0 animated:YES];
    [self.genreSegControl insertSegmentWithTitle:@"hip-hop" atIndex:1 animated:YES];
    [self.genreSegControl addTarget:self action:@selector(makeGenreStageSelection) forControlEvents:UIControlEventValueChanged];
    
    self.accelX = [[NSString alloc]init];
    self.accelY = [[NSString alloc]init];
    self.accelZ = [[NSString alloc]init];
    
    self.accelOldX = [[NSString alloc]init];
    self.accelOldY = [[NSString alloc]init];
    self.accelOldZ = [[NSString alloc]init];
    
    self.gyroX = [[NSString alloc]init];
    self.gyroY = [[NSString alloc]init];
    self.gyroZ = [[NSString alloc]init];

    self.motionManager = [[CMMotionManager alloc]init];
    
    self.recordingIndication.backgroundColor = [UIColor redColor];
    self.recordingText.text = @"choose a stage to record dance activity";
}


-(void)makeGenreStageSelection
{
    
    switch (self.genreSegControl.selectedSegmentIndex) {
        case 0:
            self.genreStageAttending = @"Rock";
            break;
        case 1:
            self.genreStageAttending = @"Hip-hop";
            break;
        default:
            break;
    }
    
    [self performSelector:@selector(analyzeUserMotion) withObject:nil afterDelay:2];
    
    NSLog(@"the stage im attending is %@", self.genreStageAttending);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MOTION RECORDING

-(void)analyzeUserMotion
{
    
    self.recordingIndication.backgroundColor = [UIColor greenColor];
    self.recordingText.text = @"tap here to stop recording";
    
    if ([self.motionManager isAccelerometerAvailable] && [self.motionManager isGyroAvailable])
    {
     
        // GYRO
        
        [self.motionManager setGyroUpdateInterval:1.0f / 1.0f];
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            self.gyroX = [[NSString alloc]initWithFormat:@"%.02f", gyroData.rotationRate.x];
            
            self.gyroY = [[NSString alloc]initWithFormat:@"%.02f", gyroData.rotationRate.y];
            
            self.gyroZ = [[NSString alloc]initWithFormat:@"%.02f", gyroData.rotationRate.z];
            
            NSLog(@"the gyro values are %@, %@, and %@", self.gyroX, self.gyroY, self.gyroZ);
            
        }];
        
        
        // ACCEL
        
        [self.motionManager setAccelerometerUpdateInterval:1.0f / 1.0f];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            self.accelOldX = self.accelX;
            self.accelX = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.x];

            self.accelOldY = self.accelY;
            self.accelY = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.y];
            
            self.accelOldZ = self.accelZ;
            self.accelZ = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.z];
            
            [self calculateAndSendNormOfMotionActivity:self.accelX :self.accelY :self.accelZ :self.accelOldX :self.accelOldY :self.accelOldZ :self.gyroX :self.gyroY :self.gyroZ];

        }];
    
    }

}


#pragma mark - FINAL CALCULATIONS


-(void)calculateAndSendNormOfMotionActivity:(NSString *)accelXValue :(NSString *)accelYValue :(NSString *)accelZValue :(NSString *)oldXAccel :(NSString *)oldYAccel :(NSString *)oldZAccel :(NSString *)gyroXValue :(NSString *)gyroYValue :(NSString *)gyroZValue
{
    
    // conver strings to doubles
    
    // accel
    double accelX = [accelXValue doubleValue];
    double accelY = [accelYValue doubleValue];
    double accelZ = [accelZValue doubleValue];
    
    double accelOldX = [oldXAccel doubleValue];
    double accelOldY = [oldYAccel doubleValue];
    double accelOldZ = [oldZAccel doubleValue];
    
    // gyro
    double gyroX = [gyroXValue doubleValue];
    double gyroY = [gyroYValue doubleValue];
    double gyroZ = [gyroZValue doubleValue];
    
    
    // norm of gyro
    // divide each component value by the norm
    
    double gyroX2 = pow(gyroX, 2);
    double gyroY2 = pow(gyroY, 2);
    double gyroZ2 = pow(gyroZ, 2);
    double combOfGyroSq = (gyroX2 + gyroY2 + gyroZ2);
    double rootOfGyroComb = sqrt(combOfGyroSq);
    

    
    // new x minus old x equals for final equation
    
    double finalAccelX = accelX - accelOldX;
    double finalAccelY = accelY - accelOldY;
    double finalAccelZ = accelZ - accelOldZ;
    
    
    
    // create the norm of the new consolidated values
    
    double x2 = pow(finalAccelX, 2);
    double y2 = pow(finalAccelY, 2);
    double z2 = pow(finalAccelZ, 2);
    double combOfSq = (x2 + y2 + z2);
    double rootOfComb = sqrt(combOfSq);
    NSLog(@"the root of the comb is %f", rootOfComb);

    
    // configure the extra post data
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *userId = @"jared fishman";
    

    // make the post request

    NSError *error;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *serviceURL = @"http://192.168.8.221:3000/api";
    
    NSURL * url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.genreStageAttending, @"stage",
                              [NSString stringWithFormat:@"%f", rootOfComb], @"intensity",
                              [NSString stringWithFormat:@"%f", timeStamp], @"timestamp",
                              userId, @"userid",
                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    
    
    [dataTask resume];
    
}

- (IBAction)stopRecordingPressed:(UIButton *)sender {
    
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopAccelerometerUpdates];
    
    self.recordingIndication.backgroundColor = [UIColor redColor];
    self.recordingText.text = @"choose a stage to record dance activity";
}

@end
