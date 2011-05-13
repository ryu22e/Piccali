//
//  FirstViewController.h
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "ChannelViewControllerDelegate.h"
#import "ChannelViewController.h"
#import "PiccaliTwitpic.h"
#import "PiccaliWassr.h"
#import "PiccaliCommon.h"
#import "ChannelViewController.h"
#import "JSON.h"
#import "GTMUIImage+Resize.h"

#define LIBRARY_COMPRESSION_QUALITY 1.0

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ChannelViewControllerDelegate, PiccaliPostDelegate>{
    @private
    IBOutlet UIImageView *finishedPostTwitter;
    IBOutlet UIImageView *finishedPostWassr;
    IBOutlet UIImageView *errorPostTwitter;
    IBOutlet UIImageView *errorPostWassr;
    IBOutlet UIActivityIndicatorView *twitterIndicator;
    IBOutlet UIActivityIndicatorView *wassrIndicator;
    IBOutlet UISwitch *t_switch;
    IBOutlet UISwitch *w_switch;
    IBOutlet UIButton *selectWassrTargetButton;
    IBOutlet UILabel *wassrTarget;
    IBOutlet UITextView *postText;
    IBOutlet UILabel *postLengthLabel;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *postButton;
    IBOutlet UIButton *cameraButton;
    IBOutlet UIButton *libraButton;
    IBOutlet UIImageView *imageView;
    NSDictionary *targetChannel;
    UIActionSheet *channelSheet;
    ChannelViewController *channelView;
    id requestTwitter;
    id requestWassr;
    BOOL hasNewImage;
    UIImage *postImage;
    Reachability *reachability;
    BOOL keybordIsVisible;
}
@property (nonatomic, retain) UIImageView *finishedPostTwitter;
@property (nonatomic, retain) UIImageView *finishedPostWassr;
@property (nonatomic, retain) UIImageView *errorPostTwitter;
@property (nonatomic, retain) UIImageView *errorPostWassr;
@property (nonatomic, retain) UIActivityIndicatorView *twitterIndicator;
@property (nonatomic, retain) UIActivityIndicatorView *wassrIndicator;
@property (nonatomic, retain) UISwitch *t_switch;
@property (nonatomic, retain) UISwitch *w_switch;
@property (nonatomic, retain) UIButton *selectWassrTargetButton;
@property (nonatomic, retain) UILabel *wassrTarget;
@property (nonatomic, retain) UITextView *postText;
@property (nonatomic, retain) UILabel *postLengthLabel;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *postButton;
@property (nonatomic, retain) UIButton *cameraButton;
@property (nonatomic, retain) UIButton *libraButton;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSDictionary *targetChannel;
@property (nonatomic, retain) UIActionSheet *channelSheet;
@property (nonatomic, retain) ChannelViewController *channelView;
@property (nonatomic, retain) id requestTwitter;
@property (nonatomic, retain) id requestWassr;
@property (nonatomic, retain) UIImage *postImage;
@property (nonatomic ,retain) Reachability *reachability;
@end
