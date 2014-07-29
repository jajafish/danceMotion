//
//  JFDanceDataService.h
//  outsideMotion
//
//  Created by Jared Fishman on 7/28/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface JFDanceDataService : NSObject

+(instancetype)sharedDanceDataService;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) NSString *stageUserAttending;

// accel values
@property double currentAccelX;
@property double currentAccelY;
@property double currentAccelZ;
@property double oldAccelX;
@property double oldAccelY;
@property double oldAccelZ;
@property double userCurrentTravoltage;

-(void)recordUserDanceData;
-(double)analyzeUserDanceData:(double)accelX :(double)accelY :(double)accelZ :(double)oldAccelX :(double)oldAccelY :(double)oldAccelZ;
-(void)sendUserDanceData;
-(NSDictionary *)getCommunityDanceData;

@end
