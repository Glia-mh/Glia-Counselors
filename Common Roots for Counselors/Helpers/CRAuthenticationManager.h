//
//  CRAuthenticationManager.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "CRCounselor.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *CRCurrentUserKey = @"CRCurrentUserKey";

@interface CRAuthenticationManager : NSObject <LYRClientDelegate>

@property (strong, nonatomic) CRCounselor *currentUser;

+ (CRAuthenticationManager *)sharedInstance;

+ (CRCounselor *)loadCurrentUser;

+ (UIImage *)userImage;

+ (NSString *)schoolID;

+ (NSString *)schoolName;

- (NSString *)schoolNameForID:(NSString *)schoolID;

- (void)authenticateUsername:(NSString *)username password:(NSString *)password completionBlock:(void (^)(PFUser *user, NSError *error))completionBlock;

- (void)authenticateLayerWithID:(NSString *)userID client:(LYRClient *)client completionBlock:(void (^)(NSString *authenticatedUserID, NSError *error))completionBlock;

- (void)logoutUserWithClient:(LYRClient *)client completion:(void(^)(NSError *error))completion;

@end

