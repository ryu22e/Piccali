//
//  AboutCotroller.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutCotroller : UIViewController {
    @private
    IBOutlet UILabel *versionNumber;
    IBOutlet UIWebView *webView;
}
@property (nonatomic, retain) UILabel *versionNumber;
@property (nonatomic, retain) UIWebView *webView;
@end
