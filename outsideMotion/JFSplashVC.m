//
//  JFSplashVC.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/28/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFSplashVC.h"
#import "JFAppDelegate.h"
#import "JFDanceDataService.h"

@interface JFSplashVC ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *stageSegment;
@property (strong, nonatomic) JFDanceDataService *globalDanceDataService;

@end

@implementation JFSplashVC

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

    self.stageSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    [self addObserver:[JFDanceDataService sharedDanceDataService] forKeyPath:@"stageUserIsAttendingNow" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stageSegmentSelected:(UISegmentedControl *)sender {
    
    
    switch (self.stageSegment.selectedSegmentIndex) {
        case 0:
            self.stage = @"Rock";
            break;
        case 1:
            self.stage = @"Hip-hop";
            break;
        default:
            break;
    }
    
    NSLog(@"the selected stage is %@", self.stage);
    
    self.globalDanceDataService.stageUserAttending = self.stage;
    
    [self.globalDanceDataService setValue:self.stage forKeyPath:@"stageUserIsAttendingNow"];
    
    [self performSegueWithIdentifier:@"fromSplashToTab" sender:self];
    
}




@end
