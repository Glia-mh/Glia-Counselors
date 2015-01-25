//
//  UIColor+Anon.m
//  Anon
//
//  Created by Spencer Yen on 11/10/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "UIColor+Common_Roots.h"

@implementation UIColor (Common_Roots)

+ (UIColor*)unreadBlue {
    UIColor *blue = [UIColor colorWithRed:65.0f/255.0f green:131.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    return blue;
}

+ (UIColor*)commonRootsBlue {
    UIColor *blue = [UIColor colorWithRed:79.0/255.0 green:156.0/255.0 blue:196.0/255.0 alpha:1];
    return blue;
}
@end