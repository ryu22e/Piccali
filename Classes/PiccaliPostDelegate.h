//
//  PiccaliPostDelegate.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol PiccaliPostDelegate <NSObject>
@optional
- (void)failedAuthorizedTwitter:(NSError *)error;
- (void)failedToPostTwitpic:(ASIHTTPRequest *)request;
- (void)finishedToPostTwitpic:(ASIHTTPRequest *)request;
- (void)finishedToPostTwitter:(NSString *)connectionIdentifier;
- (void)failedToPostTwitter:(NSError *)error;
- (void)failedToPostWassr:(ASIHTTPRequest *)request;
- (void)finishedToPostWassr:(ASIHTTPRequest *)request;

@end
