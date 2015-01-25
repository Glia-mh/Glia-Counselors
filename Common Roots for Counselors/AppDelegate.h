//
//  AppDelegate.h
//  Common Roots for Counselors
//
//  Created by Spencer Yen on 1/25/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRAuthenticationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, retain) CRAuthenticationManager *authenticationManager;


@end

