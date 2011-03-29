//
//  SecondViewController.h
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutCotroller.h"

@interface SecondViewController : UIViewController <UITextFieldDelegate> {
	@private
	IBOutlet UITableView *configView;
	UISwitch *t_switch;
	UITextField *t_usernameField;
	UITextField *t_passwordField;
	UISwitch *w_switch;
	UITextField *w_usernameField;
	UITextField *w_passwordField;
    UITextField *imageSizeField;
    AboutCotroller *aboutController;
}
@property(nonatomic, retain) UITableView *configView;
@property(nonatomic, retain) UISwitch *t_switch;
@property(nonatomic, retain) UITextField *t_usernameField;
@property(nonatomic, retain) UITextField *t_passwordField;
@property(nonatomic, retain) UITextField *w_usernameField;
@property(nonatomic, retain) UITextField *w_passwordField;
@property(nonatomic, retain) UISwitch *w_switch;
@property(nonatomic, retain) UITextField *imageSizeField;
@property(nonatomic, retain) AboutCotroller *aboutController;
@end
