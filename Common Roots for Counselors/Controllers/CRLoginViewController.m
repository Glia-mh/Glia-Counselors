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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"currentUser"];
    [CRAuthenticationManager sharedInstance].currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
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
        [self performSegueWithIdentifier:@"presentConversationsAnimated" sender:self];
    } else {
        [self performSegueWithIdentifier:@"presentConversationsNotAnimated" sender:self];
    }
}

- (IBAction)loginTapped:(id)sender {
    
//    userID = self.studentIDTextField.text;
//    
//    if (userID.length != 0) {
//        RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle: RTSpinKitViewStyleCircleFlip color:[UIColor whiteColor] spinnerSize: 80.0f];
//        spinner.center = self.view.center;
//        [self.view addSubview: spinner];
//        
//        [[CRAuthenticationManager sharedInstance] authenticateUserID:userID completionBlock:^(BOOL authenticated) {
//            if(authenticated){
//                [[CRAuthenticationManager sharedInstance] authenticateLayerWithID:userID client:client completionBlock:^(NSString *authenticatedUserID, NSError *error) {
//                    if(!error) {
//                        [self.studentIDTextField resignFirstResponder];
//                        
//                        PFQuery *query = [PFQuery queryWithClassName:@"Counselors"];
//                        [query whereKey:@"userID" equalTo:userID];
//                        NSArray *objects = [query findObjects];
//                        if(objects) {
//                            PFObject *user = [objects firstObject];
//                            [CRAuthenticationManager sharedInstance].currentUser = [[CRUser alloc] initWithID:userID avatarString:[user objectForKey:@"Photo_URL"] name:[user objectForKey:@"Name"]];
//                            
//                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[CRAuthenticationManager sharedInstance].currentUser];
//                            [defaults setObject:data forKey:@"currentUser"];
//                            [defaults synchronize];
//                            
//                            [self presentConversationsViewControllerAnimated:YES];
//                        } else {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops, looks like you aren't a registered counselor." message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                            [alert show];
//                        }
//                    } else {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops, layer" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    }
//                }];
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Invalid id!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }
//        }];
//    }
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
