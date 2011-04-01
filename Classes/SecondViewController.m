    //
//  SecondViewController.m
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import "SecondViewController.h"
#import "PiccaliCommon.h"
#import "PiccaliAPIKey.h"
#import "AboutCotroller.h"
#import "SFHFKeychainUtils.h"

@implementation SecondViewController
@synthesize configView;
@synthesize t_switch;
@synthesize t_usernameField;
@synthesize t_passwordField;
@synthesize w_switch;
@synthesize w_usernameField;
@synthesize w_passwordField;
@synthesize imageSizeField;
@synthesize aboutController;
@synthesize twitterEngine;

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: 
            return @"Twitter";
            break;
        case 1: 
            return @"Wassr";
            break;
        case 2:
            return @"画像サイズ";
            break;
        case 3:
            return @"";
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 初期化処理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (t_switch == nil) {
        t_switch = [[UISwitch alloc] initWithFrame:CGRectMake(208, 9, 0, 0)];
        [t_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [t_switch setOn:[userDefaults boolForKey:CONFIG_TWITTER_ENABLE] animated:NO];
    }
    if (w_switch == nil) {
        w_switch = [[UISwitch alloc] initWithFrame:CGRectMake(208, 9, 0, 0)];
        [w_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [w_switch setOn:[userDefaults boolForKey:CONFIG_WASSR_ENABLE] animated:NO];
    }
    if (t_usernameField == nil) {
        t_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
        [t_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [t_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [t_usernameField setEnablesReturnKeyAutomatically:YES];
        [t_usernameField setKeyboardType:UIKeyboardTypeASCIICapable];
        [t_usernameField setReturnKeyType:UIReturnKeyDone];
        [t_usernameField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [t_usernameField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [t_usernameField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [t_usernameField setText:[userDefaults stringForKey:CONFIG_TWITTER_USERNAME]];
    }
    if (w_usernameField == nil) {
        w_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
        [w_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [w_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [w_usernameField setEnablesReturnKeyAutomatically:YES];
        [w_usernameField setKeyboardType:UIKeyboardTypeASCIICapable];
        [w_usernameField setReturnKeyType:UIReturnKeyDone];
        [w_usernameField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [w_usernameField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [w_usernameField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [w_usernameField setText:[userDefaults stringForKey:CONFIG_WASSR_USERNAME]];
    }
    if (t_passwordField == nil) {
        t_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
        [t_passwordField setEnablesReturnKeyAutomatically:YES];
        [t_passwordField setReturnKeyType:UIReturnKeyDone];
        [t_passwordField setSecureTextEntry:YES];
        [t_passwordField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [t_passwordField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [t_passwordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        NSString *username = [userDefaults stringForKey:CONFIG_TWITTER_USERNAME];
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SERVICENAME_TWITTER error:NULL];
        [t_passwordField setText:password];
    }
    if (w_passwordField == nil) {
        w_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
        [w_passwordField setEnablesReturnKeyAutomatically:YES];
        [w_passwordField setReturnKeyType:UIReturnKeyDone];
        [w_passwordField setSecureTextEntry:YES];
        [w_passwordField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [w_passwordField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [w_passwordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        NSString *username = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SERVICENAME_WASSR error:NULL];
        [w_passwordField setText:password];
    }
    if (imageSizeField == nil) {
        imageSizeField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
        [imageSizeField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [imageSizeField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [imageSizeField setEnablesReturnKeyAutomatically:YES];
        [imageSizeField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [imageSizeField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [imageSizeField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [imageSizeField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        imageSizeField.delegate = self;
        NSString *size = [userDefaults stringForKey:CONFIG_IMAGE_SIZE];
        if (size == nil || [size length] <= 0) {
            size = [[NSString alloc] initWithFormat:@"%d",DEFAULT_IMAGE_SIZE];;
        }
        [imageSizeField setText:size];
    }

        
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	if ([indexPath section] < 4) {
		switch ([indexPath row]) {
	        case 0: {
				switch ([indexPath section]) {
					case 0:
                        [[cell textLabel] setText:NSLocalizedString(@"使う", nil)];
						[cell addSubview:t_switch];
						break;
					case 1:
                        [[cell textLabel] setText:NSLocalizedString(@"使う", nil)];
						[cell addSubview:w_switch];
						break;
                    case 2:
                        [[cell textLabel] setText:NSLocalizedString(@"最大幅/高さ", nil)];
                        [cell addSubview:imageSizeField];
                        break;
                    case 3:
                        [[cell textLabel] setText:@"About Piccali"];
                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                        break;
					default:
						break;
				}
				break;
			}
			case 1:
				[[cell textLabel] setText:NSLocalizedString(@"ユーザー名", nil)];
				switch ([indexPath section]) {
					case 0:
						[cell addSubview:t_usernameField];
						break;
					case 1:
						[cell addSubview:w_usernameField];
						break;
					default:
						break;
				}
				break;
			case 2:
				[[cell textLabel] setText:NSLocalizedString(@"パスワード", nil)];
				switch ([indexPath section]) {
					case 0:
						[cell addSubview:t_passwordField];
						break;
					case 1:
						[cell addSubview:w_passwordField];
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
	// スクロールできるようにセクション数を長めに設定する。
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 3;
	} else if (section == 1) {
		return 3;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
	} else {
		return 0;
	}
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            switch([indexPath row]) {
                case 1:
                    [t_usernameField setEnabled:YES];
                    [t_usernameField becomeFirstResponder];
                    break;
                case 2:
                    [t_passwordField setEnabled:YES];
                    [t_passwordField becomeFirstResponder];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 1:
                    [w_usernameField setEnabled:YES];
                    [w_usernameField becomeFirstResponder];
                    break;
                case 2:
                    [w_passwordField setEnabled:YES];
                    [w_passwordField becomeFirstResponder];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath row]) {
                case 0:
                    [imageSizeField setEnabled:YES];
                    [imageSizeField becomeFirstResponder];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            if (!aboutController) {
                aboutController = [[AboutCotroller alloc] initWithNibName:@"AboutCotroller" bundle:nil];
            }
            [self presentModalViewController:aboutController animated:YES];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([textField isEqual:t_usernameField] || [textField isEqual:t_passwordField]) {
        [userDefaults setObject:t_usernameField.text forKey:CONFIG_TWITTER_USERNAME];
        [SFHFKeychainUtils storeUsername:t_usernameField.text andPassword:t_passwordField.text forServiceName:SERVICENAME_TWITTER updateExisting:YES error:NULL];
        if (![t_usernameField.text isEqual:@""] && ![t_passwordField.text isEqual:@""]) {
            NSLog(@"exchangeAccessTokenForUsername");
            [twitterEngine clearAccessToken];
            [twitterEngine exchangeAccessTokenForUsername:t_usernameField.text password:t_passwordField.text];
        }
    }
    if ([textField isEqual:w_usernameField] || [textField isEqual:w_passwordField]) {
        [userDefaults setObject:w_usernameField.text forKey:CONFIG_WASSR_USERNAME];
        [SFHFKeychainUtils storeUsername:w_usernameField.text andPassword:w_passwordField.text forServiceName:SERVICENAME_WASSR updateExisting:YES error:NULL];
    }
    if ([textField isEqual:imageSizeField]) {
        [userDefaults setObject:textField.text forKey:CONFIG_IMAGE_SIZE];
    }
}

- (IBAction) textFieldEditingDidEndOnExit: (UITextField *)textField {
	// リターンで編集を終了する。
	[textField resignFirstResponder];
}

- (void)switchChanged:(id)textField {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([textField isEqual:t_switch]) {
        [userDefaults setBool:[t_switch isOn] forKey:CONFIG_TWITTER_ENABLE];
    }
    if ([textField isEqual:w_switch]) {
        [userDefaults setBool:[w_switch isOn] forKey:CONFIG_WASSR_ENABLE];
    }
}

- (BOOL) textFieldEditingDidBegin: (UITextField *)textField {
    NSIndexPath *indexPath;
    if ([textField isEqual:t_usernameField]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];  
    }
    if ([textField isEqual:t_passwordField]) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    if ([textField isEqual:w_usernameField]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    if ([textField isEqual:w_passwordField]) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    if ([textField isEqual:imageSizeField]) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
	[configView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSRange match = [textField.text rangeOfString:REGEXP_IMAGE_SIZE options:NSRegularExpressionSearch];
    if (match.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

// xAuthTwitterEngineのdelegate ここから
- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [SFHFKeychainUtils getPasswordForUsername:CONFIG_CACHED_XAUTH_ACCESS_TOKEN_KEY andServiceName:SERVICENAME_TWITTER_TOKEN error:NULL];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	NSLog(@"Access token string returned: %@", tokenString);
    [SFHFKeychainUtils storeUsername:CONFIG_CACHED_XAUTH_ACCESS_TOKEN_KEY andPassword:tokenString forServiceName:SERVICENAME_TWITTER_TOKEN updateExisting:YES error:NULL];
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
}
// xAuthTwitterEngineのdelegate ここまで

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//    [super loadView];
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
    twitterEngine.consumerKey = TWITTER_CONSUMER_KEY;
    twitterEngine.consumerSecret = TWITTER_CONSUMER_SECRET;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [configView release];
    [t_switch release];
    [t_usernameField release];
    [t_passwordField release];
    [w_switch release];
    [w_usernameField release];
    [w_passwordField release];
    [imageSizeField release];
    [aboutController release];
    [twitterEngine release];
    [super dealloc];
}


@end
