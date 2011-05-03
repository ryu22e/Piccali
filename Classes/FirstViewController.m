//
//  FirstViewController.m
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController
@synthesize finishedPostTwitter;
@synthesize finishedPostWassr;
@synthesize errorPostTwitter;
@synthesize errorPostWassr;
@synthesize twitterIndicator;
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
@synthesize libraButton;
@synthesize imageView;
@synthesize targetChannel;
@synthesize channelSheet;
@synthesize channelView;
@synthesize requestTwitter;
@synthesize requestWassr;
@synthesize postImage;

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

- (UIImage *)resizeImage:(UIImage *)image {
    // UIImageのサイズを変更する。
    if (!image) {
        return nil;
    }
    // 設定画面で設定した画像の最大幅を取得する。
    NSInteger imageSize = [self getImageSize];
    CGFloat newHeight = imageSize;
    CGFloat newWidth = imageSize;
    
    // 画像のリサイズ前の幅を取得する。
    CGSize currSize = image.size;
    
    // リサイズ前の幅が最大幅以下であれば、リサイズの必要がないので元の画像をそのまま返す。
    if (currSize.width <= newWidth && currSize.height <= newHeight) {
        return image;
    } else {
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        return [image gtm_imageByResizingToSize:newSize preserveAspectRatio:YES trimToFit:NO];
    }
}

- (BOOL) hasTargetChannel {
    return targetChannel != nil;
}

// UIImageWriteToSavedPhotosAlbumのコールバック ここから
- (void) savingImageIsFinished:(UIImage *)_image 
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    NSLog(@"Finished to save image file."); //仮にコンソールに表示する
}
// UIImageWriteToSavedPhotosAlbumのコールバック ここまで

- (void)saveImage:(UIImage *)image {
    NSLog(@"saveImage start.");

    hasNewImage = NO;
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    
    NSLog(@"saveImage end.");
}

- (void)changeStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 設定画面でONになっている場合のみスイッチを有効にする。
    [t_switch setEnabled:[userDefaults boolForKey:CONFIG_TWITTER_ENABLE]];
    [w_switch setEnabled:[userDefaults boolForKey:CONFIG_WASSR_ENABLE]];
    
    // 「Wassr」が有効、かつOnの場合のみ「Wassr投稿先選択」を有効にする。
    [selectWassrTargetButton setEnabled:(w_switch.enabled && [w_switch isOn])];
    
    [postText setEditable:YES];
    
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
    
    [cameraButton setEnabled:YES];
    [libraButton setEnabled:YES];
}

- (void)resetTwitterIndicator {
    [twitterIndicator stopAnimating];
    [twitterIndicator setHidden:YES];
    [finishedPostTwitter setHidden:YES];
    [errorPostTwitter setHidden:YES];
}

- (void)resetWassrIndicator {   
    [wassrIndicator stopAnimating];
    [wassrIndicator setHidden:YES];
    [finishedPostWassr setHidden:YES];
    [errorPostWassr setHidden:YES];
}

- (void)cleanup {
    @synchronized(self) {        
        // 全ての投稿処理が終わっていれば、コントローラを初期状態に戻す。
        if (twitterIndicator.hidden && wassrIndicator.hidden) {
            // 結果がエラーになっている処理がなければ、投稿内容をクリアする。
            if (self.errorPostTwitter.hidden && self.errorPostWassr.hidden) {
                postText.text = @"";
                self.postImage = nil;
                imageView.image = nil;
            }
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self changeStatus];
        }
    }
}

- (void)notifyResultTwitter:(BOOL)hasError {
    @synchronized(self) {
        [twitterIndicator stopAnimating];
        [twitterIndicator setHidden:YES];
        if (hasError) {
            // エラーが発生した。
            [finishedPostTwitter setHidden:YES];
            [errorPostTwitter setHidden:NO];
        } else {
            // エラーが発生しなかった。
            [finishedPostTwitter setHidden:NO];
            [errorPostTwitter setHidden:YES];
        }
        [self cleanup];
    }
}

- (void)notifyResultWassr:(BOOL)hasError {
    @synchronized(self) {
        [wassrIndicator stopAnimating];
        [wassrIndicator setHidden:YES];
        if (hasError) {
            // エラーが発生した。
            [finishedPostWassr setHidden:YES];
            [errorPostWassr setHidden:NO];
        } else {
            // エラーが発生しなかった。
            [finishedPostWassr setHidden:NO];
            [errorPostWassr setHidden:YES];
        }
        [self cleanup];
    }
}

// PiccaliTwitpicのdelegate ここから
- (void)failedAuthorizedTwitter:(NSError *)error {
    // Twitterへの投稿に失敗したことを画面に通知する。
    [self notifyResultTwitter:YES];
#ifdef DEBUG
    
#endif
}

- (void)failedToPostTwitpic:(NSError *)error {
    // Twitpicへの投稿に失敗したことを画面に通知する。
    [self notifyResultTwitter:YES];
}

- (void)finishedToPostTwitpic:(ASIHTTPRequest *)request {
    // Twitpicへの投稿に成功したことを画面に通知する。
    [self notifyResultTwitter:NO];
}

- (void)failedToPostTwitter:(NSError *)error {
    // Twitterへの投稿に失敗したことを画面に通知する。
    [self notifyResultTwitter:YES];
}

- (void)finishedToPostTwitter:(NSString *)connectionIdentifier {
    // Twitterへの投稿に成功したことを画面に通知する。
    [self notifyResultTwitter:NO];
}
// PiccaliTwitpicのdelegate ここまで

// PiccaliWassrのdelegate ここから
- (void)failedToPostWassr:(ASIHTTPRequest *)request {
    // Wassrへの投稿に失敗したことを画面に通知する。
    [self notifyResultWassr:YES];
}

- (void)finishedToPostWassr:(ASIHTTPRequest *)request {
    // Wassrへの投稿に成功したことを画面に通知する。
    [self notifyResultWassr:NO];
}
// PiccaliWassrのdelegate ここまで

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
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self.view endEditing:YES];
    
    [self resetTwitterIndicator];
    [self resetWassrIndicator];
    
    BOOL postTwitter = t_switch.enabled && [t_switch isOn];
    BOOL postWassr = w_switch.enabled && [w_switch isOn];
    
    UIImage *resizedImage = [self resizeImage:self.postImage];
    
    if (hasNewImage) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 撮影した写真を保存する。
        if ([userDefaults boolForKey:CONFIG_SAVE_IMAGE]) {
            [self saveImage:self.postImage];
        }
    }
    
    if (postTwitter) {
        // Twitpicにpostする。
        [twitterIndicator startAnimating];
        [twitterIndicator setHidden:NO];
        if (!self.requestTwitter) {
            self.requestTwitter = [[PiccaliTwitpic alloc] init];
            [self.requestTwitter setDelegate:self];
        }
        [self.requestTwitter post:resizedImage message:postText.text];
    }
    if (postWassr) {
        // Wassrにpostする。
        [wassrIndicator startAnimating];
        [wassrIndicator setHidden:NO];
        if (!self.requestWassr) {
            self.requestWassr = [[PiccaliWassr alloc] init];
            [self.requestWassr setDelegate:self];
        }
        if ([self hasTargetChannel]) {
            [self.requestWassr post:resizedImage message:postText.text channel:[targetChannel objectForKey:@"name_en"]];
        } else {
            [self.requestWassr post:resizedImage message:postText.text];
        }
    }
    
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
    
    self.postImage = img;
    imageView.image = [self resizeImage:img];
    
    hasNewImage = (picker.sourceType == UIImagePickerControllerSourceTypeCamera);
    
    [self changeStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.postImage) {
        imageView.image = [self resizeImage:self.postImage];
    }
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    // 本文入力欄を角丸にする。
    postText.layer.cornerRadius = 10;
    postText.clipsToBounds = TRUE;
}

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
    [self.requestTwitter release];
    [self.requestWassr release];
    [self.postImage release];
    [super dealloc];
}

@end
