//
//  JFDanceDataService.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/28/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceDataService.h"
#import "JFAppDelegate.h"

@implementation JFDanceDataService

@synthesize stageUserAttending;


+(instancetype)sharedDanceDataService
{
    
    static JFDanceDataService *sharedDanceDataService;
    static dispatch_once_t onceToken;
    
    if (!sharedDanceDataService){
        dispatch_once(&onceToken, ^{
            sharedDanceDataService = [[self alloc]init];
        });
    }
    
    NSLog(@"allocating shared dance data service");
    
    return sharedDanceDataService;
}

-(instancetype)init
{
    self = [super init];
    
    self.motionManager = [[CMMotionManager alloc]init];
    
    
    [[JFDanceDataService sharedDanceDataService] addObserver:self forKeyPath:@"stageUserIsAttendingNow" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    
    NSLog(@"initializing shared dance data service");

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"stageUserIsAttendingNow"]) {
        self.stageUserAttending = [change valueForKeyPath:keyPath];
        NSLog(@"im getting the message, that i should change the value to %@", [change valueForKeyPath:keyPath]);
    }

    
    
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
}


// User data to send to server

-(void)recordUserDanceData
{
    NSLog(@"im recordin user dance data!");
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        
        // ACCEL
        
        [self.motionManager setAccelerometerUpdateInterval:1.0f / 1.0f];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            self.oldAccelX = self.currentAccelX;
            self.currentAccelX = [[[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.x] doubleValue];
            
            NSLog(@"old X is %f", self.oldAccelX);
            NSLog(@"X is %f", self.currentAccelX);
            
            self.oldAccelY = self.currentAccelY;
            self.currentAccelY = [[[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.y] doubleValue];
            
            NSLog(@"old Y is %f", self.oldAccelY);
            NSLog(@"Y is %f", self.currentAccelY);
            
            self.oldAccelZ = self.currentAccelZ;
            self.currentAccelZ = [[[NSString alloc]initWithFormat:@"%.02f", accelerometerData.acceleration.z] doubleValue];
            
            NSLog(@"old Z is %f", self.oldAccelZ);
            NSLog(@"Z is %f", self.currentAccelZ);
            
            [self analyzeUserDanceData:self.currentAccelX :self.currentAccelY :self.currentAccelZ :self.oldAccelX :self.oldAccelY :self.oldAccelZ];
        
        }];
        
    }
    
}

-(double)analyzeUserDanceData:(double)accelX :(double)accelY :(double)accelZ :(double)oldAccelX :(double)oldAccelY :(double)oldAccelZ
{
    
    // subtract old accel values from new accel values
    double finalAccelX = self.currentAccelX - self.oldAccelX;
    double finalAccelY = self.currentAccelY - self.oldAccelY;
    double finalAccelZ = self.currentAccelZ - self.oldAccelZ;
    
    // calculate the norm of the combination of the accel values
    double accelX2 = pow(finalAccelX, 2);
    double accelY2 = pow(finalAccelY, 2);
    double accelZ2 = pow(finalAccelZ, 2);
    double accelCombOfSq = (accelX2 + accelY2 + accelZ2);
    double accelRootOfSqComb = sqrt(accelCombOfSq);
    
    self.userCurrentTravoltage = accelRootOfSqComb;
    NSLog(@"from ANALYSIS: travoltage is %f", self.userCurrentTravoltage);
    
    [self sendUserDanceData];
    
    return self.userCurrentTravoltage;
    
}

-(void)sendUserDanceData
{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *travoltageString = [NSString stringWithFormat:@"%f", self.userCurrentTravoltage];
    NSString *userId = @"jared fishman";

    NSError *error;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // servers
    NSString *gershonLocalHost = @"http://192.168.8.221:3000/api";
    NSString *amazonServiceURL = @"http://ec2-54-80-53-189.compute-1.amazonaws.com:3000/api";
    NSString *stephanieLocalHost = @"http://50.58.157.74:3000/api";
    NSString *serviceURL = amazonServiceURL;
    NSURL * url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // post request
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.stageUserAttending, @"stage",
                              travoltageString, @"intensity",
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
    
    
    NSLog(@"from post: travoltage is %f", self.userCurrentTravoltage);
    NSLog(@"from post: stage is %@", self.stageUserAttending);
    
    NSLog(@"posting to ste");
    
    [dataTask resume];
    
}


// Community data for map and compass

-(NSDictionary *)getCommunityDanceData
{
    
    NSDictionary *communityDanceData;
    
    // get data from server, parse the info from each stage as k-v's inside the dictionary
    
    return communityDanceData;
}



@end
