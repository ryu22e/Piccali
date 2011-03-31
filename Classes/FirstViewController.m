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
#import "SFHFKeychainUtils.h"

@implementation FirstViewController
@synthesize twitterIndicator;
@synthesize resultPostTwitter;
@synthesize resultPostWassr;
@synthesize wassrIndicator;
@synthesize t_switch;
@synthesize w_switch;
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
    NSInteger maxLength;
    if (t_switch.enabled && [t_switch isOn]) {
        maxLength = MAX_LENGTH_TWITTER;
    } else if (w_switch.enabled && [w_switch isOn]) {
        maxLength = MAX_LENGTH_WASSR;
    } else {
        maxLength = MAX_LENGTH_OTHER;
    }
    return maxLength;
}

- (NSInteger) getImageSize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger imageSize = [userDefaults integerForKey:CONFIG_IMAGE_SIZE];
    if (imageSize <= 0) {
        imageSize = DEFAULT_IMAGE_SIZE;
    }
    return imageSize;
}

- (BOOL) hasTargetChannel {
    return targetChannel != nil;
}

- (void)changeStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 設定画面でONになっている場合のみスイッチを有効にする。
    [t_switch setEnabled:[userDefaults boolForKey:CONFIG_TWITTER_ENABLE]];
    [w_switch setEnabled:[userDefaults boolForKey:CONFIG_WASSR_ENABLE]];
    
    // 「Wassr」が有効、かつOnの場合のみ「Wassr投稿先選択」を有効にする。
    [selectWassrTargetButton setEnabled:(w_switch.enabled && [w_switch isOn])];
    
    NSInteger maxLength = [self getMaxLength];
    NSInteger postTextLength = [[postText text] length];
    // メッセージを入力している、かつ長さが最大文字列数以内の場合のみキャンセルボタンと投稿ボタンを有効にする。
    if (0 < postTextLength && postTextLength <= maxLength) {
        [cancelButton setEnabled:YES];
        [postButton setEnabled:YES];
        [postButton setHighlighted:YES];
    } else {
        [cancelButton setEnabled:NO];
        [postButton setEnabled:NO];
        [postButton setHighlighted:NO];
    }
    // 入力された文字列の長さを表示する。
    if (postTextLength <= maxLength) {
        // メッセージが最大文字列数を越えている場合は、文字列数を赤字で表示する。
        postLengthLabel.textColor = [UIColor whiteColor];
    } else {
        postLengthLabel.textColor = [UIColor redColor];
    }
    [postLengthLabel setText:[NSString stringWithFormat:@"%d/%d", postTextLength, maxLength]];
}

- (void)resetTwitterIndicator {
    [twitterIndicator stopAnimating];
    [twitterIndicator setHidden:YES];
    resultPostTwitter.image = nil;
    [resultPostTwitter setHidden:YES];
}

- (void)resetWassrIndicator {   
    [wassrIndicator stopAnimating];
    [wassrIndicator setHidden:YES];
    resultPostWassr.image = nil;
    [resultPostWassr setHidden:YES];
}

- (void) postToTwitter {
    //    NSURL *url = [NSURL URLWithString:TWITTER_API_URL];
    //    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest requestWithURL:url] autorelease];
    //    [urlRequest setHTTPMethod:TWITTER_API_METHOD];
    //    
    //    // パラメータの作成。
    //    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString *username = [userDefaults stringForKey:CONFIG_TWITTER_USERNAME];
    //    NSString *password = [userDefaults stringForKey:CONFIG_TWITTER_PASSWORD];
    //    NSString *message = postText.text;
    //    [params setObject:username  forKey:@"username"];
    //    [params setObject:password forKey:@"password"];
    //    [params setObject:message forKey:@"message"];
    //    [params setObject:UIImagePNGRepresentation(imageView.image) forKey:@"media"];
    //    NSMutableData *postBody = [[NSMutableData alloc] init];
    //
    //    [urlRequest setHTTPBody:postBody];
    
}

- (void) postToWassr {
    NSLog(@"postToWassr start.");
    
    [wassrIndicator startAnimating];
    [wassrIndicator setHidden:NO];
    
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
    NSString *username = [userDefaults objectForKey:CONFIG_WASSR_USERNAME];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SERVICENAME_WASSR error:NULL];
    
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
    [wassrIndicator stopAnimating];
    [wassrIndicator setHidden:YES];
    resultPostWassr.image =  [UIImage imageNamed:POST_SUCCESS_IMAGE];
    [resultPostWassr setHidden:NO];
    NSLog(@"postToWassr end.");
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    
    // TODO Twitterへの投稿とWassrへの投稿とで処理を分ける。
    [wassrIndicator stopAnimating];
    [wassrIndicator setHidden:YES];
    resultPostWassr.image =  [UIImage imageNamed:POST_ERROR_IMAGE];
    [resultPostWassr setHidden:NO];
    NSLog(@"postToWassr end.");
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

- (IBAction)switchChanged:(id)textField {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([textField isEqual:t_switch]) {
        [userDefaults setBool:[t_switch isOn] forKey:TWITTER_ENABLE];
    }
    if ([textField isEqual:w_switch]) {
        [userDefaults setBool:[w_switch isOn] forKey:WASSR_ENABLE];
    }
    
    [self changeStatus];
}

- (IBAction)cancelClicked:(id)sender {
    postText.text = @"";
    [self changeStatus];
}

- (IBAction)postClicked:(id)sender {
    NSLog(@"postClicked start.");
    
    [self resetTwitterIndicator];
    [self resetWassrIndicator];
    
    [postButton setEnabled:NO];
    
    if (t_switch.enabled && [t_switch isOn]) {
        // Twitterにpostする。
        [self postToTwitter];
    }
    if (w_switch.enabled && [w_switch isOn]) {
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [t_switch setOn:[userDefaults boolForKey:TWITTER_ENABLE]];
    [w_switch setOn:[userDefaults boolForKey:WASSR_ENABLE]];
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
    [super loadView];
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
