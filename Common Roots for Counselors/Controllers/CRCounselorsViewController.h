//
//  CRCounselorsViewController.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse-iOS/Parse.h>
#import "CRConversation.h"

@protocol CRCounselorsViewControllerDelegate;

@interface CRCounselorsViewController : PFQueryTableViewController 

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToTypeMap;
@property (nonatomic, retain) NSMutableDictionary *companies;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id <CRCounselorsViewControllerDelegate> delegate;

- (IBAction)close:(id)sender;

@end

@protocol CRCounselorsViewControllerDelegate <NSObject>
- (void)counselorsViewControllerDismissedWithConversation:(CRConversation *)conversation;
@end
