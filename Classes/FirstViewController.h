//
//  FirstViewController.h
//  Piccali
//
//  Created by ryu22e on 11/03/04.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    @private
    IBOutlet UITextView *postText;
    IBOutlet UILabel *postLengthLabel;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *postButton;
    IBOutlet UIButton *cameraButton;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic, retain) UITextView *postText;
@property (nonatomic, retain) UILabel *postLengthLabel;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *postButton;
@property (nonatomic, retain) UIButton *cameraButton;
@property (nonatomic, retain) UIImageView *imageView;
@end
