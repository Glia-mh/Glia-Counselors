//
//  CRConversation.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRUser.h"
#import <LayerKit/LayerKit.h>

@interface CRConversation : NSObject

@property (nonatomic, strong) LYRConversation *layerConversation;
@property (nonatomic, strong) NSOrderedSet *messages;
@property (nonatomic, strong) LYRMessage *latestMessage;
@property (nonatomic, strong) CRUser *participant;
@property (nonatomic) BOOL unread;

- (id)initWithParticipant:(CRUser *)aParticipant conversation:(LYRConversation *)aConversation messages:(NSOrderedSet *)aMessages latestMessage:(LYRMessage *)lMessage unread:(BOOL)aUnread;

@end
