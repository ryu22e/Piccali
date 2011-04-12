//
//  PiccaliAboutController.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliAboutController.h"


@implementation PiccaliAboutController
@synthesize versionNumber;

- (IBAction)linkClicked {
    UIWebView *webView = [[[UIWebView alloc] init] autorelease];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RYU22E_URL]]];
    [self setView:webView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    versionNumber.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [self setTitle:TITLE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
