//
//  CRLocalNotificationView.m
//  Common Roots
//
//  Created by Spencer Yen on 1/24/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRLocalNotificationView.h"

@implementation CRLocalNotificationView {
    UILabel *titleLabel;
    UILabel *notificationTextLabel;
    UIImageView *avatarImageView;
    UIView *backgroundView;
    
    float viewWidth;
}

@synthesize conversation;
@synthesize notificationText;

- (id)initWithConversation:(CRConversation *)_conversation
                      text:(NSString *)_notificationText width:(float)width{
    
    if ((self = [super initWithFrame:CGRectMake(0, -70, width, 70)])) {
        viewWidth = width;
        
        backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.9;
        [self addSubview:backgroundView];
        
        self.conversation = _conversation;
        self.notificationText = _notificationText;
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.conversation.participant.name;
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        [titleLabel setTextColor: [UIColor blackColor]];
        [self addSubview: titleLabel];

        avatarImageView = [[UIImageView alloc] init];
        avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.conversation.participant.avatarString]]];
    
        [self addSubview: avatarImageView];
        
        notificationTextLabel = [[UILabel alloc] init];
        notificationTextLabel.text = self.notificationText;
        notificationTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        [notificationTextLabel setTextColor: [UIColor darkGrayColor]];
        [self addSubview: notificationTextLabel];
        
        UITapGestureRecognizer *notificationTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationTapped:)];
        notificationTapped.numberOfTapsRequired = 1;
        notificationTapped.numberOfTouchesRequired = 1;
        notificationTapped.delegate = self;
        [self addGestureRecognizer:notificationTapped];
        
//        UISwipeGestureRecognizer *swipeDismiss = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification:)];
//        swipeDismiss.direction = UISwipeGestureRecognizerDirectionUp;
//        [self addGestureRecognizer:swipeDismiss];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    backgroundView.frame = self.frame;
    titleLabel.frame = CGRectMake(self.frame.origin.x + 65, self.frame.origin.y + 22, self.frame.size.width - 100, 20);
    
    avatarImageView.frame = CGRectMake(self.frame.origin.x + 8, CGRectGetMidY(self.frame) - 15, 45, 45);
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2;
    avatarImageView.layer.masksToBounds = YES;
    
    notificationTextLabel.frame = CGRectMake(self.frame.origin.x + 65, titleLabel.frame.origin.y + titleLabel.frame.size.height , self.frame.size.width - 100, 20);
}

- (void)notificationTapped:(UITapGestureRecognizer*)gesture {
    NSLog(@"notification tapped, load %@", self.conversation);
    if ([_delegate respondsToSelector:@selector(notificationTappedWithConversation:)]) {
        [_delegate notificationTappedWithConversation:self.conversation];
    }
}

- (void)showWithDuration:(float)time withCompletion:(void (^)(BOOL done))completionBlock{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame  = CGRectMake(0, 0, viewWidth, 70);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:time options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame  = CGRectMake(0, -70, viewWidth, 70);
        } completion:^(BOOL finished) {
            completionBlock(YES);
        }];
    }];
}

- (void)show {
    [UIView animateWithDuration:.5 delay:0.0 options:0 animations:^{
        self.frame  = CGRectMake(0, 0, viewWidth, 70);
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame  = CGRectMake(0, -70, viewWidth, 70);
    } completion:nil];
}

- (void)dismissNotification:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self hide];
}

@end
