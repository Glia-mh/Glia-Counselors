//
//  CRUser.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import <Parse/Parse.h>

@interface CRUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarString;
//@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *schoolID;
@property (nonatomic, strong) NSString *schoolName;

-(id)initWithID:(NSString *)ID avatarString:(NSString *)aAvatarString name:(NSString *)aName schoolID:(NSString *)schoolID schoolName:(NSString *)schoolName;

@end
