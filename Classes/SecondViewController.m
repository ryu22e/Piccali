    //
//  SecondViewController.m
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController
@synthesize configView;
@synthesize t_switch;
@synthesize t_usernameField;
@synthesize t_passwordField;
@synthesize w_switch;
@synthesize w_usernameField;
@synthesize w_passwordField;
@synthesize imageSizeField;
@synthesize twitterEngine;

// UITableViewのdelegate ここから
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
				switch ([indexPath section]) {
					case 0:
						[[cell textLabel] setText:NSLocalizedString(@"アカウント登録", nil)];
                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
						break;
					case 1:
                        [[cell textLabel] setText:NSLocalizedString(@"アカウント登録", nil)];
                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 1) {
		return 2;
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
                    [self.navigationController pushViewController:[[[PiccaliTwitterConfig alloc] initWithNibName:@"PiccaliTwitterConfig" bundle:nil] autorelease] animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch([indexPath row]) {
                case 1:
                    [self.navigationController pushViewController:[[[PiccaliWassrConfig alloc] initWithNibName:@"PiccaliWassrConfig" bundle:nil] autorelease] animated:YES];
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
            [self.navigationController pushViewController:[[[PiccaliAboutController alloc] initWithNibName:@"PiccaliAboutController" bundle:nil] autorelease] animated:YES];
            break;
        default:
            break;
    }
}
// UITableViewのdelegate ここまで

// UITextFieldのdelegate ここから
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([textField isEqual:imageSizeField]) {
        [userDefaults setObject:textField.text forKey:CONFIG_IMAGE_SIZE];
    }
}

- (void)textFieldEditingDidEndOnExit: (UITextField *)textField {
	// リターンで編集を終了する。
	[textField resignFirstResponder];
}

- (BOOL) textFieldEditingDidBegin: (UITextField *)textField {
    NSIndexPath *indexPath;
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
// UITextFieldのdelegate ここまで

// UISwitchのdelegate ここから
- (void)switchChanged:(id)uiswitch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([uiswitch isEqual:t_switch]) {
        [userDefaults setBool:[t_switch isOn] forKey:CONFIG_TWITTER_ENABLE];
    }
    if ([uiswitch isEqual:w_switch]) {
        [userDefaults setBool:[w_switch isOn] forKey:CONFIG_WASSR_ENABLE];
    }
}
// UISwitchのdelegate ここから

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
    // 初期化処理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    t_switch = [[UISwitch alloc] initWithFrame:CGRectMake(208, 9, 0, 0)];
    [t_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [t_switch setOn:[userDefaults boolForKey:CONFIG_TWITTER_ENABLE] animated:NO];
    
    
    w_switch = [[UISwitch alloc] initWithFrame:CGRectMake(208, 9, 0, 0)];
    [w_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [w_switch setOn:[userDefaults boolForKey:CONFIG_WASSR_ENABLE] animated:NO];
    
    
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
    [twitterEngine release];
    [super dealloc];
}


@end
