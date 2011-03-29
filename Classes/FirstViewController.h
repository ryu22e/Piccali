//
//  FirstViewController.h
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelViewControllerDelegate.h"
#import "ChannelViewController.h"

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ChannelViewControllerDelegate>{
    @private
    IBOutlet UIButton *selectWassrTargetButton;
    IBOutlet UILabel *wassrTarget;
    IBOutlet UITextView *postText;
    IBOutlet UILabel *postLengthLabel;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *postButton;
    IBOutlet UIButton *cameraButton;
    IBOutlet UIImageView *imageView;
    NSDictionary *targetChannel;
    UIActionSheet *channelSheet;
    ChannelViewController *channelView;
}
@property (nonatomic, retain) UIButton *selectWassrTargetButton;
@property (nonatomic, retain) UILabel *wassrTarget;
@property (nonatomic, retain) UITextView *postText;
@property (nonatomic, retain) UILabel *postLengthLabel;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *postButton;
@property (nonatomic, retain) UIButton *cameraButton;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSDictionary *targetChannel;
@property (nonatomic, retain) UIActionSheet *channelSheet;
@property (nonatomic, retain) ChannelViewController *channelView;
@end
