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

@interface ChannelViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    @private
    IBOutlet UIActivityIndicatorView *activityIndicator;
    UIPickerView *channelPicker;
    NSMutableArray *channelList;
    id<ChannelViewControllerDelegate> delegate;
}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIPickerView *channelPicker;
@property (nonatomic, retain) NSMutableArray *channelList;
@property (nonatomic, assign) id<ChannelViewControllerDelegate> delegate;
@end
