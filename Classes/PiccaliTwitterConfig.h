//
//  PiccaliTwitterConfig.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PiccaliCommon.h"
#import "PiccaliAPIKey.h"
#import "SFHFKeychainUtils.h"
#import "XAuthTwitterEngine.h"
#import "Reachability.h"

@interface PiccaliTwitterConfig : UIViewController {
    @private
    IBOutlet UITableView *configView;
    IBOutlet UIActivityIndicatorView *indicator;
    UITextField *t_usernameField;
	UITextField *t_passwordField;
    XAuthTwitterEngine *twitterEngine;
    Reachability *reachability;
}
@property (nonatomic, retain) UITableView *configView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) Reachability *reachability;
@end
