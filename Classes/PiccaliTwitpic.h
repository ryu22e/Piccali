//
//  PiccaliTwitpic.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiccaliPostTarget.h"
#import "PiccaliPostDelegate.h"
#import "PiccaliTwitter.h"
#import "PiccaliCommon.h"
#import "PiccaliAPIKey.h"
#import "XAuthTwitterEngine.h"
#import "OAMutableURLRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SFHFKeychainUtils.h"

#define TWITTER_VERIFY_API_URL @"https://api.twitter.com/1/account/verify_credentials.json"
#define TWITPIC_API_URL @"http://api.twitpic.com/2/upload.json"
#define TWITPIC_API_METHOD @"POST"
#define TWITPIC_COMPRESSION_QUALITY 0.8

// TODO PiccaliTwitterを継承させるのをやめる。
@interface PiccaliTwitpic : PiccaliPostTarget <PiccaliPostDelegate> {
    @private
    PiccaliTwitter *piccaliTwitter;
}
- (void)post:(UIImage *)image message:(NSString *)message;
@end
