//
//  ChannelViewController.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChannelViewController.h"
#import "ASIFormDataRequest.h"
#import "PiccaliCommon.h"
#import "JSON.h"

@implementation ChannelViewController
@synthesize activityIndicator;
@synthesize doneButton;
@synthesize channelPicker;
@synthesize channelList;
@synthesize delegate;

- (IBAction)cancelClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneClicked:(id)sender {
    [delegate channelSelected:self channel:[channelList objectAtIndex:[channelPicker selectedRowInComponent:0]]];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)clearChannelList {
    for (int i = 0; i < [channelList count]; i++) {
        id item = [channelList objectAtIndex:i];
        [item release];
    }
    [channelList removeAllObjects];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    // 列数
    return 1; 
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 行数
    return channelList.count;
}

-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *channel = [channelList objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", [channel objectForKey:@"title"]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        channelList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadChannelList {   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
    NSString *password = [userDefaults stringForKey:CONFIG_WASSR_PASSWORD];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:WASSR_CHANNEL_LIST_API_URL, username]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUsername:username];
    [request setPassword:password];
    
    request.delegate = self;
    
    [request startSynchronous];
}

- (void)showErrorDialog {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"" 
                          message:@"チャンネル一覧の取得に失敗しました。" 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString = [request responseString];
    
    NSLog(@"%@", responseString);
    
    [self clearChannelList];
    
    NSDictionary *dict = [responseString JSONValue];
    NSArray *channels = [dict objectForKey:@"channels"];
    for (int i = 0; i < [channels count]; i++) {
        NSDictionary *channel = [channels objectAtIndex:i];
        [channelList addObject:[channel retain]];        
    }
    if (0 < [channelList count]) {
        channelPicker = [[UIPickerView alloc] init];
        channelPicker.showsSelectionIndicator = YES;
        channelPicker.center = self.view.center; 
        channelPicker.delegate = self; 
        channelPicker.dataSource = self;
        [self.view addSubview:channelPicker];
        [doneButton setEnabled:YES];
    }
    
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    
    [self showErrorDialog];
    
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

- (void)dealloc
{
    [self clearChannelList];
    
    [channelList release];
    [channelPicker release];
    
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
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        activityIndicator.hidden = YES;
        // ネットワークに接続できない場合はチャンネル一覧取得処理を実行しない。
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"" 
                              message:@"ネットワークに接続できません。" 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        // Do any additional setup after loading the view from its nib.
        [activityIndicator startAnimating];
        [self loadChannelList];
    }
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
