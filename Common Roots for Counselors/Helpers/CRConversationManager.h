//
//  CRConversationManager.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "CRConversation.h"
#import "CRUser.h"
#import "JSQMessagesViewController/JSQMessages.h"
#import "CRNetworkRequest.h"
#import "CRAuthenticationManager.h"

static NSString *CRTreeNamesKey = @"CRTreeNamesKey";

extern NSString *const kConversationChangeNotification;
extern NSString *const kMessageChangeNotification;

@interface CRConversationManager : NSObject

@property (nonatomic, strong) NSMutableArray *conversations;

+ (CRConversationManager *)sharedInstance;

+ (LYRClient *)layerClient;


- (CRConversation *)CRConversationForLayerConversation:(LYRConversation *)lyrConversation client:(LYRClient *)client;

- (void)newConversationWithCounselor:(CRUser *)counselor client:(LYRClient *)layerClient completionBlock:(void (^)(CRConversation *conversation, NSError *error))completionBlock;

- (void)sendMessageToConversation:(CRConversation *)conversation message:(LYRMessage *)message client:(LYRClient *)client completionBlock:(void (^)(NSError *error))completionBlock;

- (JSQMessage *)jsqMessageForLayerMessage:(LYRMessage *)lyrMessage inConversation:(CRConversation *)conversation;

@end
