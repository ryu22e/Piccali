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
- (void)failedToPostTwitpic:(NSError *)error;
- (void)finishedToPostTwitpic:(ASIHTTPRequest *)request;
- (void)finishedToPostTwitter:(NSString *)connectionIdentifier;
- (void)failedToPostTwitter:(NSError *)error;
- (void)failedToPostWassr:(NSError *)error;
- (void)finishedToPostWassr:(ASIHTTPRequest *)request;

@end
