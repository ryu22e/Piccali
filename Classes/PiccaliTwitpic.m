//
//  PiccaliTwitpic.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliTwitpic.h"


@implementation PiccaliTwitpic

- (ASIFormDataRequest*)createOAuthEchoRequest {
	OAMutableURLRequest *oauthRequest = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TWITTER_VERIFY_API_URL]
                                                                         consumer:piccaliTwitter.twitterEngine.consumer
                                                                            token:piccaliTwitter.twitterEngine.accessToken   
                                                                            realm:@"http://api.twitter.com/"
                                                                signatureProvider:nil] autorelease];
    
    NSString *oauthHeader = [oauthRequest valueForHTTPHeaderField:@"Authorization"];
	if (!oauthHeader) {
		[oauthRequest prepare];
		oauthHeader = [oauthRequest valueForHTTPHeaderField:@"Authorization"];
	}
    
	NSLog(@"OAuth header : %@\n\n", oauthHeader);
    
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TWITPIC_API_URL]];
	request.requestMethod = TWITPIC_API_METHOD;
	request.shouldAttemptPersistentConnection = NO;
    
	[request addRequestHeader:@"X-Auth-Service-Provider" value:TWITTER_VERIFY_API_URL]; 
	[request addRequestHeader:@"X-Verify-Credentials-Authorization" value:oauthHeader];
    
	return request;
}

- (id)init {
    self = [super init];
    if (self) {
        piccaliTwitter = [[PiccaliTwitter alloc] init];
        piccaliTwitter.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [piccaliTwitter release];
    [super dealloc];
}

- (void)post:(NSString *)message {
    [piccaliTwitter post:message];
}

- (void)post:(UIImage *)image message:(NSString *)message {
    if (![piccaliTwitter.twitterEngine isAuthorized]) {
        [self.delegate failedAuthorizedTwitter:nil];
        return;
    }
    if (image) {
        // 画像をTwitpicに投稿してからTwitterに投稿する。
        NSLog(@"image");
        ASIFormDataRequest *request = [self createOAuthEchoRequest];
        
        [request setData:UIImageJPEGRepresentation(image, TWITPIC_COMPRESSION_QUALITY) forKey:@"media"];
        [request setPostValue:message  forKey:@"message"];
        [request setPostValue:TWITPIC_API_KEY  forKey:@"key"];
        
        request.delegate = self;
        
        [request startAsynchronous];
    } else {
        // Twitterに投稿する。
        NSLog(@"not image");
        [self post:message];
    }  
}

// ASIHTTPRequestのdelegate ここから
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"requestFinished");
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    NSDictionary *dic = [responseString JSONValue];
    NSString *url = [dic objectForKey:@"url"];
    if (url) {
        // TwitpicのURLをTwitterに投稿する。
        NSLog(@"url:%@", url);
        NSString *message = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"text"], url];
        [self post:message];
    } else {
        // Twitpicへの投稿に成功したことを通知する。
        [self.delegate finishedToPostTwitpic:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"requestFailed");
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    // Twitterへの投稿に失敗したことを通知する。
    [self.delegate failedToPostTwitpic:error];
}
// ASIHTTPRequestのdelegate ここまで

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

// PiccaliTwitterのdelegate ここから
- (void)failedAuthorizedTwitter:(NSError *)error {
    [self.delegate failedAuthorizedTwitter:error];
}

- (void)finishedToPostTwitter:(NSString *)connectionIdentifier {
    [self.delegate finishedToPostTwitter:connectionIdentifier];
}
// PiccaliTwitterのdelegate ここまで
@end
