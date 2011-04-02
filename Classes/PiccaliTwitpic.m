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
                                                                         consumer:twitterEngine.consumer
                                                                            token:twitterEngine.accessToken   
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.username = [userDefaults objectForKey:CONFIG_TWITTER_USERNAME];
        self.password = [SFHFKeychainUtils getPasswordForUsername:self.username andServiceName:SERVICENAME_TWITTER error:NULL];
    }
    return self;
}

- (void)post:(UIImage *)image message:(NSString *)message {
    NSLog(@"username:%@", self.username);
    NSLog(@"password:%@ ", self.password);
    msg = message; // TODO あとで消す
    if ([self.username isEqual:@""] || [self.password isEqual:@""] || ![twitterEngine isAuthorized]) {
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
        [super post:message];
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
        NSString *message = [NSString stringWithFormat:@"%@%@", msg, url];
        [super post:message];
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
    [self.delegate failedToPostTwitpic:request];
}
// ASIHTTPRequestのdelegate ここまで
@end
