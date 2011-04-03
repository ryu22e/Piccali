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
    NSLog(@"username:%@", self.username);
    NSLog(@"password:%@ ", self.password);
    if ([self.username isEqual:@""] || [self.password isEqual:@""] || ![twitterEngine isAuthorized]) {
        [self.delegate failedAuthorizedTwitter:nil];
        return;
    }
    // Twitterに投稿する。
    [twitterEngine exchangeAccessTokenForUsername:self.username password:self.password];
    [twitterEngine sendUpdate:message];
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.username = [userDefaults objectForKey:CONFIG_TWITTER_USERNAME];
        self.password = [SFHFKeychainUtils getPasswordForUsername:self.username andServiceName:SERVICENAME_TWITTER error:NULL];
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

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
    [self.delegate failedAuthorizedTwitter:error];
}
// xAuthTwitterEngineのdelegate ここまで

@end
