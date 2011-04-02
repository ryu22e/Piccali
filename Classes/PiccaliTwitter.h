//
//  PiccaliTwitter.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiccaliPostTarget.h"
#import "XAuthTwitterEngine.h"
#import "SFHFKeychainUtils.h"
#import "PiccaliAPIKey.h"
#import "PiccaliCommon.h"

@interface PiccaliTwitter : PiccaliPostTarget {
    @protected
    XAuthTwitterEngine *twitterEngine;
}
- (void)post:(NSString *)message;
@end
