//
//  CRChatViewController.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRChatViewController.h"
#import "UIColor+Common_Roots.h"

static NSString *const MIMETypeTextPlain = @"text/plain";

@interface CRChatViewController ()

@end

@implementation CRChatViewController {
    LYRClient *layerClient;
    BOOL showingNotification;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    layerClient = [CRConversationManager layerClient];
    
    self.title = self.conversation.participant.name;

    self.senderId = [CRAuthenticationManager sharedInstance].currentUser.userID;
    self.senderDisplayName = @"Me";
    
    NSLog(@"Loaded JSQ with participant: %@", self.conversation.participant.name);
    
    JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"profile-placeholder"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
#warning todo right now the user image is just a placeholder, eventually have colored trees
    JSQMessagesAvatarImage *participantImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"profile-placeholder"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    self.avatars = @{ self.senderId : userImage,
                      self.conversation.participant.userID : participantImage};

    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor teamRootsGreen]];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(kJSQMessagesCollectionViewAvatarSizeDefault, kJSQMessagesCollectionViewAvatarSizeDefault);;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;

    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" operator:LYRPredicateOperatorIsEqualTo value:self.conversation.layerConversation];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    self.queryController = [layerClient queryControllerWithQuery:query];
    self.queryController.delegate = self;
    
    NSError *error;
    BOOL success = [self.queryController execute:&error];
    if (success) {
        NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
        [self.collectionView reloadData];
    } else {
        NSLog(@"Query failed with error %@", error);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(conversationChange:)
                                                     name:kConversationChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(messageChange:)
                                                     name:kMessageChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveTypingIndicator:)
                                                     name:LYRConversationDidReceiveTypingIndicatorNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveTypingIndicator:(NSNotification *)notification
{
    NSString *participantID = notification.userInfo[LYRTypingIndicatorParticipantUserInfoKey];
    LYRTypingIndicator typingIndicator = [notification.userInfo[LYRTypingIndicatorValueUserInfoKey] unsignedIntegerValue];
    
    if (typingIndicator == LYRTypingDidBegin) {
        self.showTypingIndicator = YES;
    }
    else {
        self.showTypingIndicator = NO;
    }
}

- (void)conversationChange:(NSNotification *)notification {
// commented out because the peer side doesnt receive new conversations
    
//    NSDictionary *changeObject = (NSDictionary *)notification.object;
//    LYRConversation *conversation = changeObject[@"object"];
//    if(![conversation.participants containsObject:self.conversation.participant.userID]) {
//#warning need to change for new app
//       CRConversation *crConversation = [[CRConversationManager sharedInstance] CRConversationForLayerConversation:conversation client:layerClient];
//        CRLocalNotificationView *notificationView = [[CRLocalNotificationView alloc] initWithConversation:crConversation text:@"New Incoming Conversation!" width: self.view.frame.size.width];
//        notificationView.delegate = self;
//        [self.view addSubview:notificationView];
//        showingNotification = YES;
//        [self setNeedsStatusBarAppearanceUpdate];
//        [notificationView showWithDuration:5.0 withCompletion:^(BOOL done) {
//            showingNotification = NO;
//            [self setNeedsStatusBarAppearanceUpdate];
//        }];
//    }
}

- (void)messageChange:(NSNotification *)notification {
//    NSDictionary *changeObject = (NSDictionary *)notification.object;
//    NSLog(@"received message in chat : %@", changeObject);
//    
//    LYRMessage *message = changeObject[@"object"];
//    if(![message.sentByUserID isEqualToString:self.conversation.participant.userID] && ![message.sentByUserID isEqualToString:[CRAuthenticationManager sharedInstance].currentUser.userID]) {
//        LYRMessagePart *msgPart = [message.parts firstObject];
//        NSString *messageText = [[NSString alloc] initWithData:msgPart.data encoding:NSUTF8StringEncoding];
//        
//        CRLocalNotificationView *notificationView = [[CRLocalNotificationView alloc] initWithConversation:self.conversation text:messageText width: self.view.frame.size.width];
//        notificationView.delegate = self;
//        [self.view addSubview:notificationView];
//        showingNotification = YES;
//        [self setNeedsStatusBarAppearanceUpdate];
//        [notificationView showWithDuration:5.0 withCompletion:^(BOOL done) {
//            showingNotification = NO;
//            [self setNeedsStatusBarAppearanceUpdate];
//        }];
//    }
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    NSData *messageData = [text dataUsingEncoding:NSUTF8StringEncoding];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeTextPlain data:messageData];
    NSString *pushNotificationText = [NSString stringWithFormat:@"%@: %@", [CRAuthenticationManager sharedInstance].currentUser.name, text];
    
    NSError *error = nil;
    LYRMessage *message = [layerClient newMessageWithParts:@[ messagePart ] options:@{LYRMessageOptionsPushNotificationAlertKey:pushNotificationText, LYRMessageOptionsPushNotificationSoundNameKey: @"alert.mp3"} error:&error];
    
    [[CRConversationManager sharedInstance] sendMessageToConversation:self.conversation message:message client:layerClient completionBlock:^(NSError *error) {
        if(!error){
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            [self finishSendingMessage];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Oops."
                                                  message:@"Message failed to send. IN STAGING THIS IS PROBABLY BECAUSE OPPONENT ISNT VALID LAYER USER."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    else {
        return [self.avatars objectForKey:message.senderId];
    }
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp depending on last sent message
     */
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    if(prevPath.row < 0){
        return nil;
    } else{
        JSQMessage *previousMessage = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:prevPath] inConversation:self.conversation];
        JSQMessage *message = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
        if([previousMessage.date timeIntervalSinceDate:message.date] < -300){
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.queryController numberOfObjectsInSection:section];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
    
    if ([msg isKindOfClass:[JSQMessage class]]) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp depending on last sent message
     */
    
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    if(prevPath.row < 0){
        return 0.0f;
    }else{
        JSQMessage *previousMessage = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:prevPath] inConversation:self.conversation];
        JSQMessage *message = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
        if([previousMessage.date timeIntervalSinceDate:message.date] < -300){
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    JSQMessage *currentMessage = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:indexPath] inConversation:self.conversation];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [[CRConversationManager sharedInstance] jsqMessageForLayerMessage:[self.queryController objectAtIndexPath:prevPath] inConversation:self.conversation];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.conversation.layerConversation sendTypingIndicator:LYRTypingDidBegin];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.conversation.layerConversation sendTypingIndicator:LYRTypingDidFinish];
}

- (void)notificationTappedWithConversation:(CRConversation *)conversation {
#warning need to load new conversation
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

- (void)queryControllerWillChangeContent:(LYRQueryController *)queryController
{
}

- (void)queryController:(LYRQueryController *)controller
        didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(LYRQueryControllerChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.collectionView performBatchUpdates:^{
        switch (type) {
            case LYRQueryControllerChangeTypeInsert:
                [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                break;
            case LYRQueryControllerChangeTypeUpdate:
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                break;
            case LYRQueryControllerChangeTypeMove:
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                break;
            case LYRQueryControllerChangeTypeDelete:
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self finishReceivingMessage];
    }];
}

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController{

    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


@end
