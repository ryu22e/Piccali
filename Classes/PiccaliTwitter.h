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
    @private
    XAuthTwitterEngine *twitterEngine;
}
- (BOOL) isAuthorized;
- (void)post:(NSString *)message;
@property (nonatomic, readonly) XAuthTwitterEngine *twitterEngine;
@end
