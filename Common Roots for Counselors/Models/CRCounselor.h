//
//  CRCounselor.h
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRUser.h"

@interface CRCounselor : CRUser

@property (nonatomic, strong) NSString *counselorBio;

-(id)initWithID:(NSString *)ID avatarString:(NSString *)aAvatarString name:(NSString *)aName bio:(NSString *)aBio schoolID:(NSString *)schoolID schoolName:(NSString *)schoolName;

@end
