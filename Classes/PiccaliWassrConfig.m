//
//  PiccaliWassrConfig.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliWassrConfig.h"


@implementation PiccaliWassrConfig
@synthesize configView;

- (void)changeStatus {
    // ユーザー名とパスワードが両方入力されている場合のみSaveボタンを有効にする。
    if (![w_usernameField.text isEqualToString:@""] && ![w_passwordField.text isEqualToString:@""]) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

// UITableViewのdelegate ここから
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: 
            return @"Wassr";
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
						[cell addSubview:w_usernameField];
						break;
					default:
						break;
				}
				break;
			case 1:
				[[cell textLabel] setText:NSLocalizedString(@"パスワード", nil)];
				switch ([indexPath section]) {
					case 0:
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
                    [w_usernameField setEnabled:YES];
                    [w_usernameField becomeFirstResponder];
                    break;
                case 1:
                    [w_passwordField setEnabled:YES];
                    [w_passwordField becomeFirstResponder];
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
- (void)saveClicked:(id)sender {
    [self.view endEditing:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oldUsername = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
    NSString *oldPassword = [SFHFKeychainUtils getPasswordForUsername:oldUsername andServiceName:SERVICENAME_WASSR error:NULL];
    if ((![w_usernameField.text isEqualToString:oldUsername]) || ![w_passwordField.text isEqualToString:oldPassword]) {      
        // ユーザー名とパスワードを保存する。
        NSLog(@"Save username and password."); 
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *oldUsername = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
        if (oldUsername) {
            [SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:SERVICENAME_WASSR error:NULL];
        }
        [userDefaults setObject:w_usernameField.text forKey:CONFIG_WASSR_USERNAME];
        [SFHFKeychainUtils storeUsername:w_usernameField.text andPassword:w_passwordField.text forServiceName:SERVICENAME_WASSR updateExisting:YES error:NULL];
        
        // 前の画面に戻る。
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // ユーザー名とパスワードが変更されていない。
        NSLog(@"username and password are not changed.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// UIBarButtonItemのdelegate ここまで

// UITextFieldのdelegate ここから
- (IBAction)textFieldEditingDidEndOnExit: (UITextField *)textField {
	// リターンで編集を終了する。
	[textField resignFirstResponder];
}

- (BOOL)textFieldEditingDidBegin: (UITextField *)textField {
    NSIndexPath *indexPath;
    if ([textField isEqual:w_usernameField]) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];  
    }
    if ([textField isEqual:w_passwordField]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
	[configView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    [self changeStatus];
}
// UITextFieldのdelegate ここまで

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
    // 初期化処理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    w_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
    w_usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [w_usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [w_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [w_usernameField setEnablesReturnKeyAutomatically:YES];
    [w_usernameField setKeyboardType:UIKeyboardTypeASCIICapable];
    [w_usernameField setReturnKeyType:UIReturnKeyDone];
    [w_usernameField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:
     UIControlEventEditingDidEndOnExit];
    [w_usernameField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [w_usernameField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    w_usernameField.text = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
    
    w_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(112, 12, 190, 24)];
    w_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [w_passwordField setEnablesReturnKeyAutomatically:YES];
    [w_passwordField setReturnKeyType:UIReturnKeyDone];
    [w_passwordField setSecureTextEntry:YES];
    [w_passwordField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [w_passwordField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [w_passwordField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    NSString *username = [userDefaults stringForKey:CONFIG_WASSR_USERNAME];
    if (username) {
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SERVICENAME_WASSR error:NULL];
        w_passwordField.text = password;
    }
    
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                            style:UIBarButtonItemStyleDone target:self action:@selector(saveClicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    
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
