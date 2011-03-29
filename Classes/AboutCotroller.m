//
//  AboutCotroller.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutCotroller.h"
#import "PiccaliCommon.h"

@implementation AboutCotroller
@synthesize versionNumber;
@synthesize webView;

- (IBAction)backClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)linkClicked {
    [webView setHidden:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RYU22E_URL]]];
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

- (void)viewWillAppear:(BOOL)animated {
    [webView setHidden:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    versionNumber.text = PICCALI_VERSION;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
