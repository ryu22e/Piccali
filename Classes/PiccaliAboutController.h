//
//  PiccaliAboutController.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PiccaliCommon.h"

#define RYU22E_URL @"https://twitter.com/#!/ryu22e"
#define TITLE @"About Piccali"

@interface PiccaliAboutController : UIViewController {
@private
    IBOutlet UILabel *versionNumber;
}
@property (nonatomic, retain) UILabel *versionNumber;
@end
