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

// ACCEL
@property (strong, nonatomic) NSString *accelX;
@property (strong, nonatomic) NSString *accelY;
@property (strong, nonatomic) NSString *accelZ;

// GYRO
@property (strong, nonatomic) NSString *gyroX;
@property (strong, nonatomic) NSString *gyroY;
@property (strong, nonatomic) NSString *gyroZ;


@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.accelX = [[NSString alloc]init];
    self.accelY = [[NSString alloc]init];
    self.accelZ = [[NSString alloc]init];
    
    self.gyroX = [[NSString alloc]init];
    self.gyroY = [[NSString alloc]init];
    self.gyroZ = [[NSString alloc]init];
    

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


#pragma mark - MOTION RECORDING

-(void)analyzeUserMotion
{
    
    self.recordingIndication.backgroundColor = [UIColor greenColor];
    
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
            
            self.accelX = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.x];
            
            self.accelY = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.y];
            
            self.accelZ = [[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.z];
            
            [self calculateAndSendNormOfMotionActivity:self.accelX :self.accelY :self.accelZ :self.gyroX :self.gyroY :self.gyroZ];

        }];
    
    }

}


#pragma mark - FINAL CALCULATIONS


-(void)calculateAndSendNormOfMotionActivity:(NSString *)accelXValue :(NSString *)accelYValue :(NSString *)accelZValue :(NSString *)gyroXValue :(NSString *)gyroYValue :(NSString *)gyroZValue
{
    
    // conver strings to doubles
    
    // accel
    double accelX = [accelXValue doubleValue];
    double accelY = [accelYValue doubleValue];
    double accelZ = [accelZValue doubleValue];
    
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
    
    double gyroXDivNorm = gyroX / rootOfGyroComb;
    double gyroYDivNorm = gyroY / rootOfGyroComb;
    double gyroZDivNorm = gyroZ / rootOfGyroComb;
    

    // subtract gyro values from accell values
    
    double x = accelX - gyroXDivNorm;
    double y = accelY - gyroYDivNorm;
    double z = accelZ - gyroZDivNorm;
    
    
    // create the norm of the new consolidated values
    
    double x2 = pow(x, 2);
    double y2 = pow(y, 2);
    double z2 = pow(z, 2);
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


@end
