//
//  CRUser.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRUser.h"

@implementation CRUser

-(id)initWithID:(NSString *)ID avatarString:(NSString *)aAvatarString name:(NSString *)aName schoolID:(NSString *)schoolID schoolName:(NSString *)schoolName {
    self = [super init];
    if(self) {
        self.userID = ID;
        self.avatarString = aAvatarString;
        self.name = aName;
        self.schoolID = schoolID;
        self.schoolName = schoolName;
        //self.bio = aBio;
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.avatarString forKey:@"avatarString"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.schoolID forKey:@"schoolID"];
    [encoder encodeObject:self.schoolName forKey:@"schoolName"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(!self ) {
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.avatarString = [decoder decodeObjectForKey:@"avatarString"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.schoolID = [decoder decodeObjectForKey:@"schoolID"];
    self.schoolName = [decoder decodeObjectForKey:@"schoolName"];
    
    return self;
}

@end
