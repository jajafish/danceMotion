//
//  JFDanceDataService.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/28/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceDataService.h"

@implementation JFDanceDataService

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
    
    NSLog(@"initializing shared dance data service");
    
    return self;
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
    
    double travoltage = accelRootOfSqComb;
    NSLog(@"travoltage is %f", travoltage);
    
    return travoltage;
}

-(void)sendUserDanceData
{
    
}


// Community data for map and compass

-(NSDictionary *)getCommunityDanceData
{
    
    NSDictionary *communityDanceData;
    
    // get data from server, parse the info from each stage as k-v's inside the dictionary
    
    return communityDanceData;
}



@end
