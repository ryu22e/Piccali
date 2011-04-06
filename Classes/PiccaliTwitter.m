//
//  PiccaliTwitter.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliTwitter.h"


@implementation PiccaliTwitter
@synthesize twitterEngine;

- (BOOL) isAuthorized {
    return [twitterEngine isAuthorized];
}

- (void)post:(NSString *)message {
    if (![self.twitterEngine isAuthorized]) {
        [self.delegate failedAuthorizedTwitter:nil];
        return;
    }
    // Twitterに投稿する。
    [twitterEngine sendUpdate:message];
}

- (id)init {
    self = [super init];
    if (self) {
        twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
        twitterEngine.consumerKey = TWITTER_CONSUMER_KEY;
        twitterEngine.consumerSecret = TWITTER_CONSUMER_SECRET;
    }
    return self;
}

- (void)dealloc {
    [twitterEngine release];
    [super dealloc];
}

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
    [self.delegate finishedToPostTwitter:connectionIdentifier];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    NSLog(@"Twitter request failed: %@", connectionIdentifier);
    [self.delegate failedToPostTwitter:error];
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
    [self.delegate failedAuthorizedTwitter:error];
}
// xAuthTwitterEngineのdelegate ここまで

@end
