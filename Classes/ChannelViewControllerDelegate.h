//
//  ChannelViewControllerDelegate.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChannelViewControllerDelegate <NSObject>
@optional
- (void) channelSelected:(UIViewController *)controller channel:(NSDictionary *)selectedChannel;
@end
