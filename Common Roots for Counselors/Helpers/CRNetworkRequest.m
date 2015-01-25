//
//  CRNetworkRequest.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "CRNetworkRequest.h"

@implementation CRNetworkRequest

- (void)performRequest:(void (^)())completionBlock {
    completionBlock(nil);
}

@end
