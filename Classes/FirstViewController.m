//
//  FirstViewController.m
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import "FirstViewController.h"
#import "PiccaliCommon.h"
#import "ChannelViewController.h"
#import "ASIFormDataRequest.h"

@implementation FirstViewController
@synthesize selectWassrTargetButton;
@synthesize wassrTarget;
@synthesize postText;
@synthesize postLengthLabel;
@synthesize cancelButton;
@synthesize postButton;
@synthesize cameraButton;
@synthesize imageView;
@synthesize targetChannel;
@synthesize channelSheet;
@synthesize channelView;

- (NSInteger) getMaxLength {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger maxLength;
    if ([userDefaults boolForKey:USERDEFAULTS_TWITTER_ENABLE]) {
        maxLength = MAX_LENGTH_TWITTER;
    } else if ([userDefaults boolForKey:USERDEFAULTS_WASSR_ENABLE]) {
        maxLength = MAX_LENGTH_WASSR;
    } else {
        maxLength = MAX_LENGTH_OTHER;
    }
    return maxLength;
}

- (NSInteger) getImageSize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger imageSize = [userDefaults integerForKey:USERDEFAULTS_IMAGE_SIZE];
    if (imageSize <= 0) {
        imageSize = DEFAULT_IMAGE_SIZE;
    }
    return imageSize;
}

- (void) postToTwitter {
//    NSURL *url = [NSURL URLWithString:TWITTER_API_URL];
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest requestWithURL:url] autorelease];
//    [urlRequest setHTTPMethod:TWITTER_API_METHOD];
//    
//    // パラメータの作成。
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *username = [userDefaults stringForKey:USERDEFAULTS_TWITTER_USERNAME];
//    NSString *password = [userDefaults stringForKey:USERDEFAULTS_TWITTER_PASSWORD];
//    NSString *message = postText.text;
//    [params setObject:username  forKey:@"username"];
//    [params setObject:password forKey:@"password"];
//    [params setObject:message forKey:@"message"];
//    [params setObject:UIImagePNGRepresentation(imageView.image) forKey:@"media"];
//    NSMutableData *postBody = [[NSMutableData alloc] init];
//
//    [urlRequest setHTTPBody:postBody];
    
}

- (BOOL) hasTargetChannel {
    return targetChannel != nil;
}

- (void) postToWassr {
    NSLog(@"postToWassr start.");
    NSString *statusOrBody;
    NSString *source;
    NSURL *url;
    if ([self hasTargetChannel]) {
        // チャンネルに投稿する。
        NSString *targetChannelName = [targetChannel objectForKey:@"name_en"];
        url = [NSURL URLWithString:[NSString stringWithFormat:WASSR_CHANNEL_API_URL, targetChannelName]];
        source = nil;
        statusOrBody = @"body";
    } else {
        // タイムラインに投降する。 
        url = [NSURL URLWithString:WASSR_API_URL];
        source = WASSR_API_SOURCE;
        statusOrBody = @"status";
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:USERDEFAULTS_WASSR_USERNAME];
    NSString *password = [userDefaults stringForKey:USERDEFAULTS_WASSR_PASSWORD];
    
    [request setUsername:username];
    [request setPassword:password];
    if (source != nil) {
        [request addPostValue:WASSR_API_SOURCE forKey:@"source"];
    }
    [request addPostValue:postText.text forKey:statusOrBody];
    if (imageView.image != nil) {
        NSData *imageData = [[[NSData alloc] initWithData:UIImagePNGRepresentation(imageView.image)] autorelease];
        [request setData:imageData forKey:@"image"];
    }
    
    request.delegate = self;
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    // TODO Twitterへの投稿とWassrへの投稿とで処理を分ける。
    NSLog(@"postToWassr end.");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    
    // TODO Twitterへの投稿とWassrへの投稿とで処理を分ける。
    NSLog(@"postToWassr end.");
}

- (void)changeStatus {
    NSInteger maxLength = [self getMaxLength];
    NSInteger postTextLength = [[postText text] length];
    if (0 < postTextLength && postTextLength <= maxLength) {
        [cancelButton setEnabled:YES];
        [postButton setEnabled:YES];
    } else {
        [cancelButton setEnabled:NO];
        [postButton setEnabled:NO];
    }
    if (postTextLength <= maxLength) {
        postLengthLabel.textColor = [UIColor whiteColor];
    } else {
        postLengthLabel.textColor = [UIColor redColor];
    }
    [postLengthLabel setText:[NSString stringWithFormat:@"%d/%d", postTextLength, maxLength]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	// リターンで編集を終了する。
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self changeStatus];
}

- (IBAction)cancelClicked:(id)sender {
    postText.text = @"";
    [self changeStatus];
}

- (IBAction)postClicked:(id)sender {
    NSLog(@"postClicked start.");
    [postButton setEnabled:NO];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:USERDEFAULTS_TWITTER_ENABLE]) {
        // Twitterにpostする。
        [self postToTwitter];
    }
    if ([userDefaults boolForKey:USERDEFAULTS_WASSR_ENABLE]) {
        // Wassrにpostする。
        [self postToWassr];
    }
    
    [postButton setEnabled:YES];
    NSLog(@"postClicked end.");
}

- (IBAction) selectWassrTargetClicked:(id)sender {
    if (!channelSheet) {
        channelSheet = [[UIActionSheet alloc] 
                        initWithTitle:@"投稿先を選択してください" 
                        delegate:self 
                        cancelButtonTitle:@"キャンセル" 
                        destructiveButtonTitle:nil 
                        otherButtonTitles:@"タイムライン", @"チャンネル", nil];
    }
    [channelSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == channelSheet) {
        switch (buttonIndex) {
            case 0:
                targetChannel = nil;
                wassrTarget.text = @"タイムライン";
                break;
            case 1:
                if (!channelView) {
                    channelView = [[ChannelViewController alloc] initWithNibName:@"ChannelViewController" bundle:nil];
                    channelView.delegate = self;
                }
                [self presentModalViewController:channelView animated:YES];
                break;
            default:
                break;
        }
    }
}

- (void) channelSelected:(UIViewController *)controller channel:(NSDictionary *)selectedChannel {
    targetChannel = [selectedChannel retain];
    wassrTarget.text = [NSString stringWithFormat:@"#%@", [targetChannel objectForKey:@"title"]];
}

- (IBAction)cameraOrLibraryClicked:(id)sender {
    UIImagePickerControllerSourceType sourceType = 0;
    if (sender == cameraButton) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //イメージピッカーを表示する(カメラ or ライブラリの起動)
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    // UIImageのサイズを変更する。
    UIImage *image = img;
    NSInteger imageSize = [self getImageSize];
    CGSize size = CGSizeMake(imageSize, imageSize);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageView.image = resizedImage;
    
    [self changeStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeStatus];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [targetChannel release];
    [channelSheet release];
    [channelView release];
    [super dealloc];
}

@end
