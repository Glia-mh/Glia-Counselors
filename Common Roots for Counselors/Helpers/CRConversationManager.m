//
//  CRConversationManager.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRConversationManager.h"
#import "CRAuthenticationManager.h"
#import "CRCounselor.h"

NSString * const kConversationChangeNotification = @"ConversationChange";
NSString * const kMessageChangeNotification = @"MessageChange";

@implementation CRConversationManager


+ (CRConversationManager *)sharedInstance {
    static CRConversationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CRConversationManager alloc] init];
        
    });
    return _sharedInstance;
}

+ (LYRClient *)layerClient {
    static LYRClient *_layerClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"e25bc8da-9f52-11e4-97ea-142b010033d0"];
        _layerClient = [LYRClient clientWithAppID:appID];
    });
    return _layerClient;
}

- (CRConversation *)CRConversationForLayerConversation:(LYRConversation *)lyrConversation client:(LYRClient *)client {
    LYRQuery *messagesQuery = [LYRQuery queryWithClass:[LYRMessage class]];
    messagesQuery.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:lyrConversation];
    messagesQuery.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    
    NSError *error;
    NSOrderedSet *messages = [client executeQuery:messagesQuery error:&error];
    
    LYRMessage *latestMessage = [messages lastObject];

    BOOL unread;
    if(LYRRecipientStatusRead == [latestMessage recipientStatusForUserID:[[CRAuthenticationManager sharedInstance] currentUser].userID])  {
        unread = NO;
    } else {
        unread = YES;
    }
   
    //    NSData *participantMetadata = [participantJSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *participantDictionary = [NSJSONSerialization JSONObjectWithData:participantMetadata options:0 error:nil];
    
    NSString *studentName = [[lyrConversation.metadata valueForKey:@"student"] valueForKey:@"name"];
    
    if(studentName.length == 0){
        studentName = [self randomTreeNameCombination];
        [lyrConversation setValue:studentName forMetadataAtKeyPath:@"student.name"];
    }
    
    CRUser *participant = [[CRUser alloc] initWithID:[[lyrConversation.metadata valueForKey:@"student"] valueForKey:@"ID"] avatarString:[[lyrConversation.metadata valueForKey:@"student"] valueForKey:@"avatarString"] name:[[lyrConversation.metadata valueForKey:@"student"] valueForKey:@"name"] schoolID:[lyrConversation.metadata valueForKey:@"schoolID"] schoolName:[[CRAuthenticationManager sharedInstance] schoolNameForID:[lyrConversation.metadata valueForKey:@"schoolID"]]];
    NSLog(@"participant name: %@", participant.name);
    
    CRConversation *crConversation = [[CRConversation alloc] initWithParticipant:participant conversation:lyrConversation messages:messages latestMessage:latestMessage unread:unread];
    
    return crConversation;
}

- (void)sendMessageToConversation:(CRConversation *)conversation message:(LYRMessage *)message client:(LYRClient *)client completionBlock:(void (^)(NSError *error))completionBlock {
    NSError *error;
    BOOL success = [conversation.layerConversation sendMessage:message error:&error];
    if (success) {
        completionBlock(nil);
    } else {
        completionBlock(error);
    }
}

- (JSQMessage *)jsqMessageForLayerMessage:(LYRMessage *)lyrMessage inConversation:(CRConversation *)conversation{
    LYRMessagePart *part = [lyrMessage.parts firstObject];
    NSString *messageText = [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
    
    NSString *senderDisplayName;
    if([lyrMessage.sentByUserID isEqualToString:[[CRAuthenticationManager sharedInstance] currentUser].userID]) {
        senderDisplayName = [[CRAuthenticationManager sharedInstance] currentUser].name;
    } else {
        senderDisplayName = conversation.participant.name;
    }
#warning this is pretty hacky, since jsq reloads messages right after its sent so lyr doenst have a sentat property yet...
    if(lyrMessage.sentAt) {
        return [[JSQMessage alloc] initWithSenderId:lyrMessage.sentByUserID
                                      senderDisplayName:senderDisplayName
                                                   date:lyrMessage.sentAt
                                                   text:messageText];
    } else {
        return [[JSQMessage alloc] initWithSenderId:lyrMessage.sentByUserID
                                      senderDisplayName:senderDisplayName
                                                   date:[NSDate date]
                                                   text:messageText];
    }
}

- (NSString *)randomTreeNameCombination {
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:CRTreeNamesKey];
    NSArray *existingTrees = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSArray *colors = @[@"Red", @"Green", @"Blue", @"Purple", @"Orange", @"Yellow", @"Violet", @"Pink", @"Gray", @"Brown", @"Cyan", @"Crimson" , @"Gold" , @"Silver" , @"Teal" , @"Azure", @"Turquoise", @"Lavender", @"Maroon", @"Tan", @"Magenta" , @"Indigo" , @"Jade", @"Scarlet", @"Amber"];
    NSArray *trees = @[@"Acacia", @"Aspen" , @"Beech" , @"Birch" , @"Cedar" , @"Cypress", @"Ebony", @"Elm" , @"Eucalyptus", @"Fir", @"Grove" , @"Hazel" ,  @"Juniper" , @"Maple", @"Oak" , @"Palm", @"Poplar", @"Pine" , @"Sequoia" ,  @"Spruce", @"Sycamore", @"Sylvan",  @"Walnut", @"Willow", @"Yew"];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", colors[arc4random() % 25], trees[arc4random() % 25]];

    if(existingTrees) {
        while (![existingTrees containsObject:name]) {
            name = [NSString stringWithFormat:@"%@ %@", colors[arc4random() % 25], trees[arc4random() % 25]];
        }
    }
    
    NSLog(@"name: %@", name);
    return name;
}
 
@end
