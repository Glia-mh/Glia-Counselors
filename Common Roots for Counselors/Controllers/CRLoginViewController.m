//
//  CRLoginViewController.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRLoginViewController.h"
#import "RTSpinKitView.h"
#import "UIColor+Common_Roots.h"

@interface CRLoginViewController ()

@end

@implementation CRLoginViewController {
    LYRClient *client;
    BOOL showingNotification;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderColor = [UIColor teamRootsGreen].CGColor;
    self.loginButton.layer.borderWidth = 1.2f;
    self.loginButton.layer.cornerRadius = 5.f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUserAuthenticationStatus];
}

- (void)checkUserAuthenticationStatus {
    [CRAuthenticationManager sharedInstance].currentUser = [CRAuthenticationManager loadCurrentUser];
    
    if ([CRAuthenticationManager sharedInstance].currentUser != nil) {
        [self presentConversationsViewControllerAnimated:NO];
    } else {
        client = [CRConversationManager layerClient];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    assert([([navController viewControllers][0]) isKindOfClass:[CRConversationsViewController class]]);
    CRConversationsViewController *conversationVC = (CRConversationsViewController *)([navController viewControllers][0]);
    if(self.receivedConversationToLoad) {
        conversationVC.receivedConversationToLoad = self.receivedConversationToLoad;
    }
}

- (void)presentConversationsViewControllerAnimated:(BOOL)animated {
    if(animated) {
        [self performSegueWithIdentifier:@"ModalConversationsVC" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ModalConversationsVCNotAnimated" sender:self];
    }
}

- (IBAction)loginTapped:(id)sender {
    
    if(self.emailField.text.length != 0 && self.passwordField.text.length != 0) {
        [[CRAuthenticationManager sharedInstance] authenticateUsername:self.emailField.text password:self.passwordField.text completionBlock:^(PFUser *user, NSError *error) {
            if(user && !error) {
                NSLog(@"authed with parse, id: %@", user.objectId);
                [[CRAuthenticationManager sharedInstance] authenticateLayerWithID:user.objectId client:client completionBlock:^(NSString *authenticatedUserID, NSError *error) {
                    [CRAuthenticationManager sharedInstance].currentUser = [[CRCounselor alloc] initWithID:user.objectId avatarString:[user objectForKey:@"photoURL"] name:[user objectForKey:@"name"] bio:[user objectForKey:@"bio"] schoolID:[user objectForKey:@"schoolID"]];

                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[CRAuthenticationManager sharedInstance].currentUser];
                    [defaults setObject:data forKey:CRCurrentUserKey];
                    [defaults synchronize];

                    [self presentConversationsViewControllerAnimated:YES];
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops, Parse login error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)notCounselorTapped:(id)sender {
}

- (void)notificationTappedWithConversation:(CRConversation *)conversation {
    NSLog(@"notificaiton tappeD: %@", conversation);
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
