//
//  CRLoginViewController.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "CRConversation.h"
#import "CRUser.h"
#import "CRConversationsViewController.h"
#import "CRAuthenticationManager.h"
#import "CRConversationManager.h"
#import "CRLocalNotificationView.h"

@interface CRLoginViewController : UIViewController <CRLocalNotificationViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CRConversation *receivedConversationToLoad;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginTapped:(id)sender;
- (IBAction)notCounselorTapped:(id)sender;

@end
