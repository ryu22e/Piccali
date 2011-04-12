//
//  PiccaliTwitterConfig.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliTwitterConfig.h"


@implementation PiccaliTwitterConfig
@synthesize configView;
@synthesize indicator;

- (void)changeStatus {
    // ユーザー名とパスワードが両方入力されている場合のみLogin & Saveボタンを有効にする。
    if (![t_usernameField.text isEqualToString:@""] && ![t_passwordField.text isEqualToString:@""]) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)cleanup {
    @synchronized(self) {
        [indicator stopAnimating];
        [indicator setHidden:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (void)save:(NSString *)username AndPassword:(NSString *)password {
    NSLog(@"Save username and password."); 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oldUsername = [userDefaults stringForKey:CONFIG_TWITTER_USERNAME];
    if (oldUsername) {
        [SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:SERVICENAME_TWITTER error:NULL];
    }
    [userDefaults setObject:username forKey:CONFIG_TWITTER_USERNAME];
    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:SERVICENAME_TWITTER updateExisting:YES error:NULL];
}

// UITableViewのdelegate ここから
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: 
            return @"Twitter";
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	if ([indexPath section] < 1) {
		switch ([indexPath row]) {
			case 0:
				[[cell textLabel] setText:NSLocalizedString(@"ユーザー名", nil)];
				switch ([indexPath section]) {
					case 0:
						[cell addSubview:t_usernameField];
						break;
					default:
						break;
				}
				break;
			case 1:
				[[cell textLabel] setText:NSLocalizedString(@"パスワード", nil)];
				switch ([indexPath section]) {
					case 0:
						[cell addSubview:t_passwordField];
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else {
		return 0;
	}
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            switch([indexPath row]) {
                case 0:
                    [t_usernameField setEnabled:YES];
                    [t_usernameField becomeFirstResponder];
                    break;
                case 1:
                    [t_passwordField setEnabled:YES];
                    [t_passwordField becomeFirstResponder];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}
// UITableViewのdelegate ここまで

// UIBarButtonItemのdelegate ここから
- (void)loginAndSaveClicked:(id)sender {
    [self.view endEditing:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [indicator startAnimating];
    [indicator setHidden:NO];
    
    // Twitterのアクセストークンを取得する。
    NSLog(@"exchangeAccessTokenForUsername");
    [twitterEngine exchangeAccessTokenForUsername:t_usernameField.text password:t_passwordField.text];
}
// UIBarButtonItemのdelegate ここまで

// UITextFieldのdelegate ここから
- (void)textFieldEditingDidEndOnExit: (UITextField *)textField {
	// リターンで編集を終了する。
	[textField resignFirstResponder];
}

- (BOOL)textFieldEditingDidBegin: (UITextField *)textField {
    NSIndexPath *indexPath;
    if ([textField isEqual:t_usernameField]) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];  
    }
    if ([textField isEqual:t_passwordField]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
	[configView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    [self changeStatus];
}
// UITextFieldのdelegate ここまで

// xAuthTwitterEngineのdelegate ここから
- (void)storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	NSLog(@"Access token string returned: '%@'", tokenString);
    [SFHFKeychainUtils storeUsername:CONFIG_CACHED_XAUTH_ACCESS_TOKEN_KEY andPassword:tokenString forServiceName:SERVICENAME_TWITTER_TOKEN updateExisting:YES error:NULL];
    if (tokenString && ![tokenString isEqualToString:@""]) {
        @synchronized(self) {
            // ユーザー名とパスワードを保存する。
            [self save:t_usernameField.text AndPassword:t_passwordField.text];
            [self cleanup];
            // 前の画面に戻る。
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
    // TODO エラーになった旨を画面に出力する。
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"" 
                          message:@"Twitterへのログインに失敗しました。" 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
	[alert show];
	[alert release];
    [self cleanup];
}
// xAuthTwitterEngineのdelegate ここまで

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
    [t_usernameField release];
    [t_passwordField release];
    [twitterEngine release];
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
    // 初期化処理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    t_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
    [t_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [t_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [t_usernameField setEnablesReturnKeyAutomatically:YES];
    [t_usernameField setKeyboardType:UIKeyboardTypeASCIICapable];
    [t_usernameField setReturnKeyType:UIReturnKeyDone];
    [t_usernameField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:
     UIControlEventEditingDidEndOnExit];
    [t_usernameField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [t_usernameField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    t_usernameField.text = [userDefaults stringForKey:CONFIG_TWITTER_USERNAME];
    
    t_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
    [t_passwordField setEnablesReturnKeyAutomatically:YES];
    [t_passwordField setReturnKeyType:UIReturnKeyDone];
    [t_passwordField setSecureTextEntry:YES];
    [t_passwordField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [t_passwordField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [t_passwordField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    NSString *username = [userDefaults stringForKey:CONFIG_TWITTER_USERNAME];
    if (username) {
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SERVICENAME_TWITTER error:NULL];
        t_passwordField.text = password;
    }
    
    twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
    twitterEngine.consumerKey = TWITTER_CONSUMER_KEY;
    twitterEngine.consumerSecret = TWITTER_CONSUMER_SECRET;
    
    UIBarButtonItem *loginAndSaveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Login & Save" 
                                                          style:UIBarButtonItemStyleDone target:self action:@selector(loginAndSaveClicked:)] autorelease];
    loginAndSaveButton.width = (CGFloat)270;
    self.navigationItem.rightBarButtonItem = loginAndSaveButton;
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    
    [self setTitle:@"Twitter"];
    
    [self changeStatus];
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
