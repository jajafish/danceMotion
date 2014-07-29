//
//  JFDanceMapVC.m
//  outsideMotion
//
//  Created by Jared Fishman on 7/26/14.
//  Copyright (c) 2014 Jared Fishman. All rights reserved.
//

#import "JFDanceMapVC.h"

@interface JFDanceMapVC ()
@property (strong, nonatomic) IBOutlet UIWebView *danceMapWebView;

@end

@implementation JFDanceMapVC

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

    self.danceMapWebView.delegate = self;
    
    self.danceMapWebView.scrollView.scrollEnabled = NO;
    self.danceMapWebView.scrollView.bounces = NO;
    
    NSString *urlString = @"http://ec2-54-242-29-209.compute-1.amazonaws.com/map_mobile.html";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length])[self.danceMapWebView loadRequest:request];
    }];
    
    
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize contentSize = self.danceMapWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    self.danceMapWebView.scrollView.minimumZoomScale = rw;
    self.danceMapWebView.scrollView.maximumZoomScale = rw;
    self.danceMapWebView.scrollView.zoomScale = rw;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
