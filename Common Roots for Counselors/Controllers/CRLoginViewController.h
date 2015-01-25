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
@property (strong, nonatomic) IBOutlet UILabel *sloganLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UITextView *disclaimerTextView;
@property (strong, nonatomic) IBOutlet UITextField *studentIDTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginTapped:(id)sender;

@end
