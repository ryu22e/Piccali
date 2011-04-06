//
//  PiccaliWassr.m
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PiccaliWassr.h"

@implementation PiccaliWassr
@synthesize delegate;
@synthesize username;
@synthesize password;

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.username = [userDefaults objectForKey:CONFIG_WASSR_USERNAME];
        self.password = [SFHFKeychainUtils getPasswordForUsername:self.username andServiceName:SERVICENAME_WASSR error:NULL];
    }
    return self;
}

- (void)post:(UIImage *)image message:(NSString *)message {
    [self post:image message:message channel:nil];
}

- (void)post:(UIImage *)image message:(NSString *)message channel:(NSString *)channel {
    NSString *statusOrBody;
    NSString *source;
    NSURL *url;
    if (channel) {
        // チャンネルに投稿する。
        url = [NSURL URLWithString:[NSString stringWithFormat:WASSR_CHANNEL_API_URL, channel]];
        source = nil;
        statusOrBody = @"body";
    } else {
        // タイムラインに投降する。 
        url = [NSURL URLWithString:WASSR_API_URL];
        source = WASSR_API_SOURCE;
        statusOrBody = @"status";
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUsername:self.username];
    [request setPassword:self.password];
    if (source != nil) {
        [request addPostValue:WASSR_API_SOURCE forKey:@"source"];
    }
    [request addPostValue:message forKey:statusOrBody];
    if (image != nil) {
        [request setData:UIImageJPEGRepresentation(image, WASSR_COMPRESSION_QUALITY) forKey:@"image"];
    }
    
    request.delegate = self;
    
    [request startAsynchronous];
}

// ASIHTTPRequestのdelegate ここから
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"requestFinished");
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    // Wassrへの投稿に成功したことを通知する。
    [self.delegate finishedToPostWassr:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"requestFailed");
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    // Wassrへの投稿に失敗したことを通知する。
    [self.delegate failedToPostWassr:request];
}
// ASIHTTPRequestのdelegate ここまで
@end
