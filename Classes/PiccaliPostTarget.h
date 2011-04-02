//
//  PiccaliPostTarget.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/04/02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiccaliPostDelegate.h"

@interface PiccaliPostTarget : NSObject {
@private
    id<PiccaliPostDelegate> delegate;
    NSString *username;
    NSString *password;
}
@property (nonatomic, assign) id<PiccaliPostDelegate> delegate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@end
