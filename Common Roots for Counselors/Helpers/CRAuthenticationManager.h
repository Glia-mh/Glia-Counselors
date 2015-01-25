//
//  CRAuthenticationManager.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "CRUser.h"
#import <CommonCrypto/CommonDigest.h>

@interface CRAuthenticationManager : NSObject <LYRClientDelegate>

@property (strong, nonatomic) CRUser *currentUser;

+ (CRAuthenticationManager *)sharedInstance;

+ (CRUser *)currentUser;

- (void)authenticateUserID:(NSString *)userID completionBlock:(void (^)(BOOL authenticated))completionBlock;

- (void)authenticateLayerWithID:(NSString *)userID client:(LYRClient *)client completionBlock:(void (^)(NSString *authenticatedUserID, NSError *error))completionBlock;

- (NSString*)md5String:(NSString*)input;

@end

