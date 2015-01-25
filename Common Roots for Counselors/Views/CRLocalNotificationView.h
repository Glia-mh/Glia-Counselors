//
//  CRLocalNotificationView.h
//  Common Roots
//
//  Created by Spencer Yen on 1/24/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRConversation.h"

@protocol CRLocalNotificationViewDelegate;

@interface CRLocalNotificationView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<CRLocalNotificationViewDelegate> delegate;
@property (strong, nonatomic) CRConversation *conversation;
@property (strong, nonatomic) NSString *notificationText;

- (void)show;
- (void)hide;
- (void)showWithDuration:(float)time withCompletion:(void (^)(BOOL done))completionBlock;
- (void)notificationTapped:(UITapGestureRecognizer*)gesture;

- (id)initWithConversation:(CRConversation *)_conversation
                      text:(NSString *)_notificationText width:(float)width;
@end

@protocol CRLocalNotificationViewDelegate <NSObject>

- (void)notificationTappedWithConversation:(CRConversation *)conversation;

@end
