//
//  PiccaliWassrConfig.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PiccaliCommon.h"
#import "SFHFKeychainUtils.h"

@interface PiccaliWassrConfig : UIViewController {
    @private
    IBOutlet UITableView *configView;
    UITextField *w_usernameField;
	UITextField *w_passwordField;
}
@property (nonatomic, retain) UITableView *configView;
@end
