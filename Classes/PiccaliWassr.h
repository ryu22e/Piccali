//
//  *
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiccaliPostTarget.h"
#import "PiccaliCommon.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SFHFKeychainUtils.h"
#import "PiccaliPostDelegate.h"

#define WASSR_API_URL @"http://api.wassr.jp/statuses/update.json"
#define WASSR_CHANNEL_API_URL @"http://api.wassr.jp/channel_message/update.json?name_en=%@"
#define WASSR_CHANNEL_LIST_API_URL @"http://api.wassr.jp/channel_user/user_list.json?login_id=%@"
#define WASSR_API_METHOD @"POST"
#define WASSR_API_SOURCE @"Piccali"
#define WASSR_COMPRESSION_QUALITY 0.8

@interface PiccaliWassr : NSObject {
@private
    id<PiccaliPostDelegate> delegate;
    NSString *username;
    NSString *password;
}
@property (nonatomic, assign) id<PiccaliPostDelegate> delegate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (void)post:(UIImage *)image message:(NSString *)message;
- (void)post:(UIImage *)image message:(NSString *)message channel:(NSString *)channel;
@end
