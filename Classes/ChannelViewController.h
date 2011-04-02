//
//  ChannelViewController.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelViewControllerDelegate.h"
#import "ASIFormDataRequest.h"

#define WASSR_CHANNEL_LIST_API_URL @"http://api.wassr.jp/channel_user/user_list.json?login_id=%@"

@interface ChannelViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    @private
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIBarButtonItem *doneButton;
    UIPickerView *channelPicker;
    NSMutableArray *channelList;
    id<ChannelViewControllerDelegate> delegate;
}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIPickerView *channelPicker;
@property (nonatomic, retain) NSMutableArray *channelList;
@property (nonatomic, assign) id<ChannelViewControllerDelegate> delegate;
@end
