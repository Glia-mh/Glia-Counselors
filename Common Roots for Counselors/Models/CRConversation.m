//
//  CRConversation.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRConversation.h"

@implementation CRConversation

- (id)initWithParticipant:(CRUser *)aParticipant conversation:(LYRConversation *)aConversation messages:(NSOrderedSet *)aMessages latestMessage:(LYRMessage *)lMessage unread:(BOOL)aUnread {
    self = [super init];
    if(self) {
        self.layerConversation = aConversation;
        self.participant = aParticipant;
        self.messages = aMessages;
        self.latestMessage = lMessage;
        self.unread = aUnread;
    }
    return self;
}

@end
